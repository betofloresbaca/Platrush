class_name FlyingEnemyFlyState extends State

@export var character: FlyingEnemy

const speed: float = 100

@onready
var animated_sprite: AnimatedSprite2D = character.get_node("AnimatedSprite2D")


func enter(context: Dictionary):
	super.enter(context)
	animated_sprite.play("fly")


func process(delta: float):
	super.process(delta)
	character.velocity.x = character.direction.x * speed
	animated_sprite.flip_h = character.velocity.x >= 0
	character.move_and_slide()


func _on_bounce_detector_area_entered(area):
	if is_active:
		character.direction.x *= -1


func _on_chase_detector_body_exited(body: CharacterBody2D):
	if is_active:
		print(body.global_position)
		transitioned.emit("Chase", {"target": body.global_position})
