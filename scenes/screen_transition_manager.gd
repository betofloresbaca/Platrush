extends Node

@export
var screen_transition_scene : PackedScene

@export
var main_menu_scene: PackedScene

@export
var game_complete_scene: PackedScene

func transition_to_scene(target_scene: PackedScene):
	for button in get_tree().get_nodes_in_group("animated_button"):
		button.disabled = true
	await get_tree().create_timer(0.2).timeout
	var transition_instance = screen_transition_scene.instantiate()
	add_child(transition_instance)
	await transition_instance.screen_covered
	get_tree().change_scene_to_packed(target_scene)


func transition_to_menu():
	transition_to_scene(main_menu_scene)
	
func transition_to_game_complete():
	transition_to_scene(game_complete_scene)
