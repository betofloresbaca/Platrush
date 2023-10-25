extends CanvasLayer

signal back_pressed

@onready
var window_mode_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainerWindow/HBoxContainer/WindowModeButton
@onready
var music_volume_control = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/MusicVolume/MusicVolumeRangeControl
@onready
var sfx_volume_control = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/MusicVolume/MusicVolumeRangeControl

var full_screen = false


func _ready():
	_update_initial_volume_settings()


func _on_window_mode_button_pressed():
	full_screen = not full_screen
	if full_screen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	update_button_text()


func update_button_text():
	window_mode_button.text = "FULL SCREEN" if full_screen else "WINDOWED"


func _on_back_button_pressed():
	emit_signal("back_pressed")


func _on_music_volume_range_control_percentage_changed(percent):
	_set_bus_volume("Music", percent)


func _on_sfx_volume_range_control_percentage_changed(percent):
	_set_bus_volume("SFX", percent)


func _update_initial_volume_settings():
	var percent_music = _get_bus_volume("Music")
	music_volume_control.set_current_percent(percent_music)
	var percent_sfx = _get_bus_volume("SFX")
	sfx_volume_control.set_current_percent(percent_sfx)


func _set_bus_volume(bus_name, percent):
	var busIdx = AudioServer.get_bus_index(bus_name)
	var volumeDb = linear_to_db(percent)
	AudioServer.set_bus_volume_db(busIdx, volumeDb)


func _get_bus_volume(bus_name):
	var busIdx = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(busIdx)
	return db_to_linear(volume_db)
