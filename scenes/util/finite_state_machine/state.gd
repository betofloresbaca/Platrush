extends Node

class_name State

signal transitioned

var is_new_state: bool

func init():
	pass

func enter():
	is_new_state = true

func exit():
	pass

func process(delta: float):
	disable_is_new_state.call_deferred()
	
func physics_process(delta: float):
	pass


func disable_is_new_state():
	is_new_state = false

