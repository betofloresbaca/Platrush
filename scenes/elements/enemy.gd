extends CharacterBody2D

@export var enemy_death_scene: PackedScene
@export var is_spawning = true

const max_speed = 25
const gravity = 500

var direction: Vector2
var start_direction = Vector2.RIGHT


func _ready():
	direction = start_direction


func _process(delta):
	if is_spawning:
		return
	velocity.x = (direction * max_speed).x
	velocity.y += gravity * delta
	move_and_slide()
	$Visuals/AnimatedSprite2D.flip_h = direction.x > 0


func _on_bounce_detector_area_entered(_area):
	direction.x *= -1


func _on_hurtbox_area_area_entered(_area):
	kill.call_deferred()


func kill():
	var death_instance = enemy_death_scene.instantiate()
	get_parent().add_child(death_instance)
	death_instance.global_position = global_position
	if velocity.x > 0:
		death_instance.scale = Vector2(-1, 1)
	queue_free()
