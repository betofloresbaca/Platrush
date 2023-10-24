extends Node

func apply_camera_shake(percentage):
	var camera = get_tree().get_first_node_in_group("camera")
	if camera != null:
		camera.apply_shake(percentage)
