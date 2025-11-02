extends Node3D

#gets all the car parts
@onready var Front_Wheel_Left= $Body/Front_Wheel_Left
@onready var Front_Wheel_Right= $Body/Front_Wheel_Right
@onready var Back_Wheel_Left= $Body/Back_Wheel_Left
@onready var Back_Wheel_Right= $Body/Back_Wheel_Right

#sets the max for speed en turn circle
@export var Max_Turn = 0.9
@export var Max_Speed = 10

var Left_Input: float = 0.0
var Right_Input: float = 0.0
var Brake_Input: float = 0.0
var Acceleration_Input: float = 0.0

var Speed_Input: float = 0.0
var Steer_Input: float = 0.0

var Forward_Direction
var velocity = Vector3.ZERO

func set_inputs(left: float, right: float, brake:float, acceleration: float):
	Left_Input = left
	Right_Input = right
	Brake_Input = brake
	Acceleration_Input = acceleration
	
	
	
func _physics_process(delta: float):
	
	
	# abs for absulote and we need some speed to turn the car
	if abs(Speed_Input) > 0.1:
		rotation.y += Steer_Input * Max_Turn
		
	Forward_Direction = -transform.basis.z
	
	 # Set velocity (normalize for constant speed)
	velocity = Forward_Direction * Speed_Input
	if velocity.length() > 0:
		velocity = velocity.normalized() * Max_Speed

	global_position += velocity * delta
	
func _process(delta):
	
	
	Speed_Input = Acceleration_Input - Brake_Input * Max_Speed
	Steer_Input = Left_Input - Right_Input * Max_Turn
	Front_Wheel_Left.rotation.x = Steer_Input
	Front_Wheel_Right.rotation.x = Steer_Input
	
	
