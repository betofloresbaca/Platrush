class_name PlayerDashState extends State


const max_dash_speed = 600
const min_dash_speed = 200


func _init(_parent_node: Node):
	super(_parent_node)
	self.name = "DASH"

func process(delta: float, is_state_new: bool):
	super.process(delta, is_state_new)
	var pn = self.parent_node
	if is_state_new:
		node("DashAudioPlayer").play()
		node("DashParticles").emitting = true
		Helpers.apply_camera_shake(0.75)
		node("EnemyKill/CollisionShape2D").disabled = false
		node("AnimatedSprite2D").play("jump")
		node("Hurtbox").collision_mask = pn.dash_hurtbox_mask
		var move_vector = pn.get_movement_vector()
		var vel_mod = 1
		if move_vector.x != 0:
			vel_mod = sign(move_vector.x)
		else:
			vel_mod = 1 if node("AnimatedSprite2D").flip_h else -1
		pn.velocity.x = vel_mod * max_dash_speed
		pn.velocity.y = 0
	pn.move_and_slide()
	pn.velocity.x = lerpf(0, pn.velocity.x, pow(2, -8 * delta))
	if abs(pn.velocity.x) < min_dash_speed:
		self.state_change.emit("NORMAL")
