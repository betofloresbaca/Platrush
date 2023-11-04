class_name FlyingEnemy extends Enemy

var direction: Vector2


func params(parameters: Dictionary):
	direction = parameters.get("start_direction")


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
