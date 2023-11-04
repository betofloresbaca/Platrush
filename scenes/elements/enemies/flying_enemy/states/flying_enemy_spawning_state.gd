class_name FlyingEnemySpawningState extends State

@export var character: FlyingEnemy


func init():
	pass


func enter():
	character.get_node("AnimatedSprite2D").play("chase")


func exit():
	pass


func process(delta: float):
	pass


func physics_process(delta: float):
	pass
