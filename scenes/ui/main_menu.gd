extends CanvasLayer

func _on_play_button_pressed():
	LevelManager.change_level(0)


func _on_options_button_pressed():
	$MarginContainer.hide()
	$OptionsMenu.show()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_options_menu_back_pressed():
	$MarginContainer.show()
	$OptionsMenu.hide()
