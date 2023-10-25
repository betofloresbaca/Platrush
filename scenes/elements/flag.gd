extends Node2D

signal player_won


func _on_win_area_area_entered(_area):
	$WinAudioPlayer.play()
	$AnimationPlayer.play("won")


func emit_player_won():
	emit_signal("player_won")
