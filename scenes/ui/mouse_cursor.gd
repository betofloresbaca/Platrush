extends CanvasLayer

var previous_mouse_position = Vector2.ZERO

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _process(_delta):
	var new_mouse_position = $Sprite2D.get_global_mouse_position()
	$Sprite2D.global_position = new_mouse_position
	if Input.is_action_just_pressed("click"):
		$AnimationPlayer.play("click")
		previous_mouse_position = Vector2.ZERO
	mouse_auto_show_hide(new_mouse_position)
	

func mouse_auto_show_hide(mouse_position):
	var mouse_activity = false
	if mouse_position != previous_mouse_position:
		mouse_activity = true
	if mouse_activity:
		$Sprite2D.show()
		if not $HideTimer.is_stopped():
			$HideTimer.stop()
	if not mouse_activity and $HideTimer.is_stopped():
		$HideTimer.start()
	previous_mouse_position = mouse_position

func _on_hide_timer_timeout():
	$Sprite2D.hide()
