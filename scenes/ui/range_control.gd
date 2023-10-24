extends HBoxContainer

signal percentage_changed

var current_percent = 1

func set_current_percent(percent):
	current_percent =  clamp(percent, 0, 1);
	$Label.text = str(round(current_percent * 10))
	emit_signal("percentage_changed", current_percent)


func _on_substract_button_pressed():
	set_current_percent(current_percent - 0.1)


func _on_add_button_pressed():
	set_current_percent(current_percent + 0.1)
