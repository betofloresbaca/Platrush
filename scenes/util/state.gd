class_name State extends Object

signal state_change

var name: String
var parent_node: Node


func _init(_parent_node: Node):
	self.parent_node = _parent_node


func process(delta: float, is_state_new: bool):
	pass


func node(path: String):
	return self.parent_node.get_node(path)
