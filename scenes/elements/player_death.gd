extends CharacterBody2D

const gravity = 1000


func _ready():
	$DeathSoundPlayer.play()
	if velocity.x < 0:
		scale = Vector2(-1, 1)


func _process(delta):
	velocity.y += gravity * delta
	move_and_slide()
	if is_on_floor():
		velocity = lerp(Vector2.ZERO, velocity, pow(2, -5 * delta))
