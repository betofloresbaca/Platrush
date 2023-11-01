class_name PlayerInputDisabledState extends State

@export var player: CharacterBody2D

func enter():
	player.get_node("AnimatedSprite2D").play("idle")


func process(delta: float):
	super.process(delta)
	player.velocity.x = lerpf(0, player.velocity.x, pow(2, player.lerp_pow * delta))
	player.velocity.y += player.gravity * player.jump_termination_multiplier * delta
	player.move_and_slide()
