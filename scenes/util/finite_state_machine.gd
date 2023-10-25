extends Node

@export
var states_scripts: Array[Script]

@export
var current_state_name: String

var states_map: Dictionary
var current_state: State
var is_state_new: bool = true


func _ready():
	self.states_map = {}
	for state_script in states_scripts:
		var state: State = state_script.new(get_parent())
		state.state_change.connect(self.change_state)
		states_map[state.name] = state
	current_state = states_map[current_state_name]


func _process(delta):
	current_state.process(delta, self.is_state_new)
	self.is_state_new = false


func change_state(new_state_name: String):
	self._deferred_change_state.call_deferred(new_state_name)


func _deferred_change_state(new_state_name: String):
	if(states_map.has(new_state_name)):
		self.is_state_new = true
		current_state = states_map[new_state_name]
