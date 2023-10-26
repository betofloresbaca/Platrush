extends Camera2D

@export var background_color: Color
@export var shake_noise: Noise

const lerp_power = -10
const max_shake_ofset = 8
const x_noise_sample_direction = Vector2.RIGHT
const y_noise_sample_direction = Vector2.DOWN
const noise_sample_travel_rate = 500
const shake_decay = 4

var player_position = Vector2.ZERO
var shake_percentage = 0
var x_noise_sample_position = Vector2.ZERO
var y_noise_sample_position = Vector2.ZERO


func _ready():
	make_current()
	# TODO set background_color


func _process(delta):
	follow_player(delta)
	shake(delta)


func apply_shake(percentage):
	shake_percentage = clampf(shake_percentage + percentage, 0, 1)


func follow_player(delta):
	if not get_target_position_from_group("player"):
		get_target_position_from_group("player_death")
	global_position = lerp(
		player_position, global_position, pow(2, lerp_power * delta)
	)


func get_target_position_from_group(group_name):
	var node = get_tree().get_first_node_in_group(group_name)
	if node != null:
		player_position = node.global_position
		return true
	return false


func shake(delta):
	if shake_percentage > 0:
		x_noise_sample_position += (
			x_noise_sample_direction * noise_sample_travel_rate * delta
		)
		y_noise_sample_position += (
			y_noise_sample_direction * noise_sample_travel_rate * delta
		)
		var x_sample = shake_noise.get_noise_2d(
			x_noise_sample_position.x, x_noise_sample_position.y
		)
		var y_sample = shake_noise.get_noise_2d(
			y_noise_sample_position.x, y_noise_sample_position.y
		)
		offset = (
			Vector2(x_sample, y_sample)
			* max_shake_ofset
			* pow(shake_percentage, 2)
		)
		shake_percentage = clamp(shake_percentage - shake_decay * delta, 0, 1)
