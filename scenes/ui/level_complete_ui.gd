extends CanvasLayer



func _on_restart_button_pressed():
	LevelManager.restart_level()


func _on_next_level_button_pressed():
	LevelManager.increment_level()
