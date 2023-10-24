extends CharacterBody2D

signal died

@export var player_death_scene: PackedScene
@export var footstep_scene: PackedScene
@export_flags_2d_physics var dash_hurtbox_mask
@export var facing = Vector2.RIGHT

enum State {NORMAL, DASH, INPUT_DISABLED}

const gravity =  1000
const max_x_speed = 140
const x_acceleration = 2000
const jump_speed = 300
const lerp_pow = -40
const jump_termination_multiplier = 5
const max_jumps = 2
const max_dashes = 1
const max_dash_speed = 600
const min_dash_speed = 200

var jump_counter = 0
var dash_counter = 0
var current_state = State.NORMAL
var is_state_new = true
var default_hurtbox_mask = 0
var is_dying = false

func _ready():
	default_hurtbox_mask = $Hurtbox.collision_mask
	$AnimatedSprite2D.flip_h = facing == Vector2.RIGHT

func _process(delta):
	match current_state:
		State.NORMAL:
			process_normal(delta)
		State.DASH:
			process_dash(delta)
		State.INPUT_DISABLED:
			process_input_disabled(delta)
	is_state_new = false

func change_state(new_state):
	current_state = new_state
	is_state_new = true

func process_dash(delta):
	if is_state_new:
		$DashAudioPlayer.play()
		$DashParticles.emitting = true
		Helpers.apply_camera_shake(0.75)
		$EnemyKill/CollisionShape2D.disabled = false
		$AnimatedSprite2D.play("jump")
		$Hurtbox.collision_mask = dash_hurtbox_mask
		var move_vector = get_movement_vector()
		var vel_mod = 1
		if move_vector.x != 0:
			vel_mod = sign(move_vector.x)
		else:
			vel_mod = 1 if $AnimatedSprite2D.flip_h else -1
		velocity.x = vel_mod * max_dash_speed
		velocity.y = 0
	move_and_slide()
	velocity.x = lerpf(0, velocity.x, pow(2, -8 * delta))
	if abs(velocity.x) < min_dash_speed:
		call_deferred("change_state", State.NORMAL)

func process_input_disabled(delta):
	if is_state_new:
		$AnimatedSprite2D.play("idle")
	velocity.x = lerpf(0, velocity.x, pow(2, lerp_pow * delta))
	velocity.y += gravity * jump_termination_multiplier * delta;
	move_and_slide()
	

func process_normal(delta):
	if is_state_new:
		$DashParticles.emitting = false
		$EnemyKill/CollisionShape2D.disabled = true
		$Hurtbox.collision_mask = default_hurtbox_mask
	var move_vector = get_movement_vector()
	
	# Calculate x movement
	velocity.x += move_vector.x * x_acceleration * delta
	if move_vector.x == 0:
		velocity.x = lerpf(0, velocity.x, pow(2, lerp_pow * delta))
	velocity.x = clampf(velocity.x, -max_x_speed, max_x_speed)
	
	# Calculate y movement
	var can_jump = is_on_floor() or not $CoyoteTimer.is_stopped() or jump_counter < max_jumps
	if move_vector.y < 0 and can_jump:
		Helpers.apply_camera_shake(0.75)
		velocity.y = move_vector.y * jump_speed
		jump_counter += 1
		$CoyoteTimer.stop()
	
	if velocity.y < 0 and not Input.is_action_pressed("jump"):
		velocity.y += gravity * jump_termination_multiplier * delta;
		if velocity.y > 0:
			velocity.y = 0
	else:
		velocity.y += gravity * delta
	var was_on_floor = is_on_floor()
	move_and_slide()
	
	# Double jump and coyote time
	if is_on_floor():
		jump_counter = 0
		dash_counter = 0
		if not was_on_floor and not is_state_new:
			spawn_footstep()
	elif was_on_floor:
		$CoyoteTimer.start()
	
	if Input.is_action_just_pressed("dash") and dash_counter < max_dashes:
		dash_counter += 1
		call_deferred("change_state", State.DASH)
	
	update_animation(move_vector)

# Gets the move vector input
func get_movement_vector():
	var move_vector = Vector2.ZERO
	move_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_vector.y = int(Input.is_action_just_pressed("jump")) * -1
	return move_vector

func update_animation(move_vector: Vector2):
	if not is_on_floor():
		$AnimatedSprite2D.play("jump")
	elif move_vector.x != 0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
	if move_vector.x != 0:
		$AnimatedSprite2D.flip_h = move_vector.x > 0

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
	change_state(State.INPUT_DISABLED)

func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.animation == "run":# and $AnimatedSprite2D.frame == 0:
		spawn_footstep()

func _on_animated_sprite_2d_animation_changed():
	if $AnimatedSprite2D.animation == "run":
		spawn_footstep()

func spawn_footstep():
	var footstep = footstep_scene.instantiate()
	get_parent().add_child(footstep)
	footstep.global_position = global_position
	$FootstepsSoundPlayer.play()

