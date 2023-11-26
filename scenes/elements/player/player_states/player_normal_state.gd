class_name PlayerNormalState extends State

@export var player: CharacterBody2D

const max_jumps = 2
const max_x_speed = 140
const x_acceleration = 2000
const jump_speed = 300
const max_dashes = 1

var jump_counter: int = 0
var dash_counter: int = 0
var default_hurtbox_mask


func init():
	super.init()
	self.default_hurtbox_mask = player.get_node("Hurtbox").collision_mask


func enter(context: Dictionary):
	super.enter(context)
	player.get_node("DashParticles").emitting = false
	player.get_node("EnemyKill/CollisionShape2D").disabled = true
	player.get_node("Hurtbox").collision_mask = default_hurtbox_mask


func process(delta: float):
	super.process(delta)
	var move_vector = player.get_movement_vector()
	# Calculate x movement
	player.velocity.x += move_vector.x * x_acceleration * delta
	if move_vector.x == 0:
		player.velocity.x = lerpf(
			0, player.velocity.x, pow(2, player.lerp_pow * delta)
		)
	player.velocity.x = clampf(player.velocity.x, -max_x_speed, max_x_speed)

	# Calculate y movement
	var can_jump = (
		player.is_on_floor()
		or not player.get_node("CoyoteTimer").is_stopped()
		or self.jump_counter < max_jumps
	)
	if move_vector.y < 0 and can_jump:
		Helpers.apply_camera_shake(0.75)
		player.velocity.y = move_vector.y * jump_speed
		self.jump_counter += 1
		player.get_node("CoyoteTimer").stop()

	if player.velocity.y < 0 and not Input.is_action_pressed("jump"):
		player.velocity.y += (
			player.gravity * player.jump_termination_multiplier * delta
		)
		if player.velocity.y > 0:
			player.velocity.y = 0
	else:
		player.velocity.y += player.gravity * delta
	var was_on_floor = player.is_on_floor()
	player.move_and_slide()

	# Double jump and coyote time
	if player.is_on_floor():
		self.jump_counter = 0
		self.dash_counter = 0
		if not was_on_floor and not is_new_state:
			player.spawn_footstep()
	elif was_on_floor:
		player.get_node("CoyoteTimer").start()

	if Input.is_action_just_pressed("dash") and self.dash_counter < max_dashes:
		self.dash_counter += 1
		self.transitioned.emit("Dash", {})

	update_animation(move_vector)


func update_animation(move_vector: Vector2):
	if not player.is_on_floor():
		player.get_node("AnimatedSprite2D").play("jump")
	elif move_vector.x != 0:
		player.get_node("AnimatedSprite2D").play("run")
	else:
		player.get_node("AnimatedSprite2D").play("idle")
	if move_vector.x != 0:
		player.get_node("AnimatedSprite2D").flip_h = move_vector.x > 0
