class_name FlyingEnemySpawningState extends State

@export var character: FlyingEnemy


func enter(context: Dictionary):
	super.enter(context)
	character.get_node("AnimatedSprite2D").play("chase")
