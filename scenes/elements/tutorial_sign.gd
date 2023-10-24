extends Node2D

@export_multiline
var text: String

@onready
var label = $PanelContainer/MarginContainer/Label

func _ready():
	label.text = text


func _on_area_2d_area_entered(_area):
	$PanelContainer.show()
	$Sprite2D.frame = 1


func _on_area_2d_area_exited(_area):
	$PanelContainer.hide()
	$Sprite2D.frame = 0

