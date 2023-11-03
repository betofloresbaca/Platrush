class_name PlayerDashState extends State

@export var player: CharacterBody2D

const max_dash_speed = 600
const min_dash_speed = 200


func enter():
	super.enter()
	player.get_node("DashAudioPlayer").play()
	player.get_node("DashParticles").emitting = true
	Helpers.apply_camera_shake(0.75)
	player.get_node("EnemyKill/CollisionShape2D").disabled = false
	player.get_node("AnimatedSprite2D").play("jump")
	player.get_node("Hurtbox").collision_mask = player.dash_hurtbox_mask
	var move_vector = player.get_movement_vector()
	var vel_mod = 1
	if move_vector.x != 0:
		vel_mod = sign(move_vector.x)
	else:
		vel_mod = 1 if player.get_node("AnimatedSprite2D").flip_h else -1
	player.velocity.x = vel_mod * max_dash_speed
	player.velocity.y = 0


func process(delta: float):
	super.process(delta)
	player.move_and_slide()
	player.velocity.x = lerpf(0, player.velocity.x, pow(2, -8 * delta))
	if abs(player.velocity.x) < min_dash_speed:
		self.transitioned.emit("Normal")
