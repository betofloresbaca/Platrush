extends Node

@export
var number_to_play = 2
@export
var enable_pitch_randomization = false
@export
var min_pitch_scale = 0.5
@export
var max_pitch_scale = 1.5
@export
var allow_sound_overlaping = false


var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()


func play():
	Enumerable\
		.new(get_children())\
		.where(func(stream_player):
			return allow_sound_overlaping or\
			 "playing" not in stream_player or\
			 not stream_player.playing\
		)\
		.shuffled()\
		.take(number_to_play)\
		.apply(_play_stream)


func _play_stream(stream_player):
	# It is a raw AudioStreamPlayer
	if  "playing" in stream_player:
		if enable_pitch_randomization:
			stream_player.pitch_scale = rng.randf_range(min_pitch_scale, max_pitch_scale)
	stream_player.play()
