extends CanvasLayer

@export
var options_menu_scene: PackedScene

func _ready():
	get_tree().paused = true

func unpause():
	queue_free()
	get_tree().paused = false

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		unpause()

func _on_continue_button_pressed():
	unpause()

func _on_options_button_pressed():
	var options_menu = options_menu_scene.instantiate()
	add_child(options_menu)
	options_menu.connect("back_pressed", Callable(self, "_on_options_back_pressed"))
	$MarginContainer.hide()


func _on_quit_button_pressed():
	ScreenTransitionManager.transition_to_menu()
	unpause()

func _on_options_back_pressed():
	$OptionsMenu.queue_free()
	$MarginContainer.show()
