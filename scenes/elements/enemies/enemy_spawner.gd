class_name EnemySpawner extends Marker2D

@export var enemy_scene: PackedScene
@export var parameters: Dictionary

var current_enemy_node = null
var spawn_on_next_tick = false


func _ready():
	spawn_enemy.call_deferred()


func spawn_enemy():
	current_enemy_node = enemy_scene.instantiate()
	current_enemy_node.params(parameters)
	get_parent().add_child(current_enemy_node)
	current_enemy_node.global_position = global_position


func check_enemy_spawn():
	if not is_instance_valid(current_enemy_node):
		if spawn_on_next_tick:
			spawn_enemy()
			spawn_on_next_tick = false
		else:
			spawn_on_next_tick = true


func _on_spawn_timer_timeout():
	check_enemy_spawn()
