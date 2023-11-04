class_name FlyingEnemyFlyState extends State

@export var character : FlyingEnemy

const speed: float = 100


func init():
	pass


func enter():
	character.get_node("AnimatedSprite2D").play("fly")


func exit():
	pass


func process(delta: float):
	character.velocity.x += character.direction.x * speed * delta
	character.move_and_slide()


func physics_process(delta: float):
	pass

