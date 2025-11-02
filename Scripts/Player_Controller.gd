extends Node


# Reference to the kart controller
@export var Car: Node3D

func _process(_delta):
	if Car == null:
		return
	

	# Read inputs
	var Left = Input.get_action_strength("Left")
	var Right = Input.get_action_strength("Right")
	var Brake = Input.get_action_strength("Backward")
	var Acceleration = Input.get_action_strength("Forward")
	
	# Send to Car
	Car.set_inputs(Left, Right , Brake, Acceleration)
