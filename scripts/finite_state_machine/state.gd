extends Node

class_name State

signal transitioned(state_name: String, context: Dictionary)

var is_new_state: bool = false
var is_active: bool = false
var context: Dictionary


func init():
	pass


func enter(context: Dictionary):
	self.context = context
	is_active = true
	is_new_state = true


func exit():
	is_active = false


func process(delta: float):
	disable_is_new_state.call_deferred()


func physics_process(delta: float):
	pass


func disable_is_new_state():
	is_new_state = false
