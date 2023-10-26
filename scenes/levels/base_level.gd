extends Node2D

@export var level_complete_scene: PackedScene
@export var pause_scene: PackedScene
@export var player_scene: PackedScene

signal coin_total_changed(collected_coins, total_coins)

#var player_scene = preload("res://scenes/elements/player.tscn")
var spawn_position = Vector2.ZERO
var current_player_node = null
var total_coins = 0
var collected_coins = 0


func _ready():
	spawn_position = $PlayerRoot/Player.global_position
	register_player($PlayerRoot/Player)
	var coins = get_tree().get_nodes_in_group("coin")
	change_coin_total(coins.size())


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var pasuse_instance = pause_scene.instantiate()
		add_child(pasuse_instance)


func coin_collected():
	collected_coins += 1
	emit_signal("coin_total_changed", collected_coins, total_coins)


func change_coin_total(new_total):
	total_coins = new_total
	emit_signal("coin_total_changed", collected_coins, total_coins)


func create_player():
	var player_instance = player_scene.instantiate()
	$PlayerRoot.add_child(player_instance)
	player_instance.global_position = spawn_position
	register_player(player_instance)


func register_player(player):
	current_player_node = player
	current_player_node.connect(
		"died", Callable(self, "_on_player_died"), CONNECT_DEFERRED
	)


func _on_player_died():
	current_player_node.queue_free()
	await get_tree().create_timer(1.5).timeout
	create_player()


func _on_flag_player_won():
	var level_complete = level_complete_scene.instantiate()
	add_child(level_complete)
