extends Node

@export var level_scenes: Array[PackedScene]

var current_level_index = 0


func change_level(level_index):
	current_level_index = level_index
	if current_level_index >= level_scenes.size():
		ScreenTransitionManager.transition_to_game_complete()
	else:
		ScreenTransitionManager.transition_to_scene(level_scenes[current_level_index])


func increment_level():
	change_level(current_level_index + 1)


func restart_level():
	change_level(current_level_index)
