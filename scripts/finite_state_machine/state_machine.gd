extends Node

class_name StateMachine

@export var initial_state: State

var current_state: State
var states: Dictionary = {}


func transition(state_name: String, context: Dictionary):
	_on_state_transitioned(state_name, context)


func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transitioned.connect(self._on_state_transitioned)
			child.init()
	if initial_state:
		current_state = initial_state
		initial_state.enter({})


func _process(delta):
	if current_state:
		current_state.process(delta)


func _physics_process(delta):
	if current_state:
		current_state.physics_process(delta)


func _on_state_transitioned(new_state_name: String, context: Dictionary):
	_deferred_on_state_transitioned.call_deferred(new_state_name, context)


func _deferred_on_state_transitioned(
	new_state_name: String, context: Dictionary
):
	if current_state.name != new_state_name and new_state_name in states:
		current_state.exit()
		current_state = states.get(new_state_name)
		current_state.enter(context)
