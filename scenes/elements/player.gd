extends CharacterBody2D

signal died

@export var player_death_scene: PackedScene
@export var footstep_scene: PackedScene
@export_flags_2d_physics var dash_hurtbox_mask
@export var facing = Vector2.RIGHT

const gravity = 1000
const lerp_pow = -40
const jump_termination_multiplier = 5

var is_dying = false


func _ready():
	$AnimatedSprite2D.flip_h = facing == Vector2.RIGHT


func get_movement_vector():
	var move_vector = Vector2.ZERO
	move_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_vector.y = int(Input.is_action_just_pressed("jump")) * -1
	return move_vector


func kill():
	if not is_dying:
		is_dying = true
		Helpers.apply_camera_shake(1)
		var player_death_instance = player_death_scene.instantiate()
		player_death_instance.velocity = velocity
		add_sibling(player_death_instance)
		player_death_instance.global_position = global_position
		emit_signal("died")


func _on_hurtbox_area_entered(_area):
	kill.call_deferred()


func _on_win_area_entered(_area):
	$MovementStateMachine.change_state("INPUT_DISABLED")


func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.animation == "run":  # and $AnimatedSprite2D.frame == 0:
		spawn_footstep()


func _on_animated_sprite_2d_animation_changed():
	if $AnimatedSprite2D.animation == "run":
		spawn_footstep()


func spawn_footstep():
	var footstep = footstep_scene.instantiate()
	get_parent().add_child(footstep)
	footstep.global_position = global_position
	$FootstepsSoundPlayer.play()
