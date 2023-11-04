class_name FlyingEnemyChaseState extends State

@export var character: FlyingEnemy


func init():
	super.init()


func enter():
	super.enter()
	character.get_node("AnimatedSprite2D").play("chase")


func exit():
	super.exit()


func process(delta: float):
	super.process(delta)


func physics_process(delta: float):
	super.physics_process(delta)
