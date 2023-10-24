extends Button

@export
var disable_hover_animation: bool = false

func _process(_delta):
	pivot_offset = size / 2


func _reset_state():
	if(!disable_hover_animation):
		$HoverAnimationPlayer.play_backwards("hover")


func _on_mouse_entered():
	if(!disable_hover_animation):
		$HoverAnimationPlayer.play("hover")


func _on_mouse_exited():
	_reset_state()


func _on_button_down():
	$AudioStreamPlayer.play()
	$ClickAnimationPlayer.play("click")


func _on_focus_exited():
	_reset_state()
