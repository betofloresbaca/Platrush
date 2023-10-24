extends Node2D


func _on_area_2d_area_entered(_area):
	$RandomAudioStreamPlayer.play()
	$AnimationPlayer.play("pickup")
	call_deferred("disable_collision")
	var base_level = get_tree().get_first_node_in_group("base_level")
	base_level.coin_collected()


func disable_collision():
	$Area2D/CollisionShape2D.disabled = true
