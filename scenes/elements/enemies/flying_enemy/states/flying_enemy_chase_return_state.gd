class_name FlyingEnemyChaseReturnState extends State

@export var character: FlyingEnemy

@onready
var animated_sprite: AnimatedSprite2D = character.get_node("AnimatedSprite2D")

const speed: float = 100
const dist_epsilon = 5;

var target: Vector2


func enter(context: Dictionary):
	super.enter(context)
	self.target = context["target"]
	character.direction = (self.target - character.global_position).normalized()
	animated_sprite.play("fly")


func process(delta: float):
	super.process(delta)
	if character.global_position.distance_to(target) < dist_epsilon:
		transitioned.emit("Fly", {})
	else:
		character.velocity = character.direction * speed
		animated_sprite.flip_h = character.velocity.x >= 0
		character.move_and_slide()
