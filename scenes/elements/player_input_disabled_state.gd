class_name PlayerInputDisabledState extends State

func _init(_parent_node: Node):
	super(_parent_node)
	self.name = "INPUT_DISABLED"

func process(delta: float, is_state_new: bool):
	super.process(delta, is_state_new)
	var pn = self.parent_node
	if is_state_new:
		node("AnimatedSprite2D").play("idle")
	pn.velocity.x = lerpf(0, pn.velocity.x, pow(2, pn.lerp_pow * delta))
	pn.velocity.y += pn.gravity * pn.jump_termination_multiplier * delta;
	pn.move_and_slide()
