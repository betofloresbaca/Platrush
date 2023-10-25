class_name PlayerNormalState extends State


const max_jumps = 2
const max_x_speed = 140
const x_acceleration = 2000
const jump_speed = 300
const max_dashes = 1


var jump_counter = 0
var dash_counter = 0
var default_hurtbox_mask


func _init(_parent_node: Node):
	super(_parent_node)
	self.name = "NORMAL"
	self.default_hurtbox_mask = node("Hurtbox").collision_mask


func process(delta: float, is_state_new: bool):
	super.process(delta, is_state_new)
	var pn = self.parent_node
	if is_state_new:
		node("DashParticles").emitting = false
		node("EnemyKill/CollisionShape2D").disabled = true
		node("Hurtbox").collision_mask = default_hurtbox_mask
	var move_vector = pn.get_movement_vector()

	# Calculate x movement
	pn.velocity.x += move_vector.x * x_acceleration * delta
	if move_vector.x == 0:
		pn.velocity.x = lerpf(0, pn.velocity.x, pow(2, pn.lerp_pow * delta))
	pn.velocity.x = clampf(pn.velocity.x, -max_x_speed, max_x_speed)

	# Calculate y movement
	var can_jump = pn.is_on_floor() or not node("CoyoteTimer").is_stopped() or self.jump_counter < max_jumps
	if move_vector.y < 0 and can_jump:
		Helpers.apply_camera_shake(0.75)
		pn.velocity.y = move_vector.y * jump_speed
		self.jump_counter += 1
		node("CoyoteTimer").stop()

	if pn.velocity.y < 0 and not Input.is_action_pressed("jump"):
		pn.velocity.y += pn.gravity * pn.jump_termination_multiplier * delta;
		if pn.velocity.y > 0:
			pn.velocity.y = 0
	else:
		pn.velocity.y += pn.gravity * delta
	var was_on_floor = pn.is_on_floor()
	pn.move_and_slide()

	# Double jump and coyote time
	if pn.is_on_floor():
		self.jump_counter = 0
		self.dash_counter = 0
		if not was_on_floor and not is_state_new:
			pn.spawn_footstep()
	elif was_on_floor:
		node("CoyoteTimer").start()

	if Input.is_action_just_pressed("dash") and self.dash_counter < max_dashes:
		self.dash_counter += 1
		self.state_change.emit("DASH")

	update_animation(move_vector)


func update_animation(move_vector: Vector2):
	var pn = self.parent_node
	if not pn.is_on_floor():
		node("AnimatedSprite2D").play("jump")
	elif move_vector.x != 0:
		node("AnimatedSprite2D").play("run")
	else:
		node("AnimatedSprite2D").play("idle")
	if move_vector.x != 0:
		node("AnimatedSprite2D").flip_h = move_vector.x > 0
