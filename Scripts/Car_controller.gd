extends CharacterBody3D


@onready var Front_Wheel_Left  = $Body/root/GLTF_SceneRootNode/Front_Wheel_Left
@onready var Front_Wheel_Right = $Body/root/GLTF_SceneRootNode/Front_Wheel_Right



@export var Max_Turn_Angle = 0.5      
@export var Max_Speed      = 15.0      
@export var Acceleration   = 10.0      
@export var Brake_Strength = 15.0     
@export var Max_Turn_Speed = 1.5   
@export var Turn_Response_Curve := 1
@export var Gravity        = 30.0      

var Driver: Node = null

var Left_Input: float = 0.0
var Right_Input: float = 0.0
var Brake_Input: float = 0.0
var Acceleration_Input: float = 0.0


var Speed: float = 0.0
var Direction: float = 1.0
var Steer_Input: float = 0.0
var Steer_Angle: float = 0.0
var Turn_Speed: float = 0.0
var Forward_Direction: Vector3


func set_inputs(left: float, right: float, brake: float, acceleration: float):
	Left_Input = left
	Right_Input = right
	Brake_Input = brake
	Acceleration_Input = acceleration

func set_driver(the_driver: Node):
	Driver = the_driver

func _physics_process(delta: float):
	#gravity
	if not is_on_floor():
		velocity.y -= Gravity * delta
	else:
		velocity.y = 0.0

									#steering		
	Steer_Input = Left_Input - Right_Input
	var target_steer = Steer_Input * Max_Turn_Angle
	Steer_Angle = lerp(Steer_Angle, target_steer, 0.2)

	#forward and backwards and come to a standstill if both are pressed
	if Acceleration_Input > 0.1 and Brake_Input < 0.1:
		Direction = 1
		Speed += Acceleration * delta
	elif Brake_Input > 0.1 and Acceleration_Input < 0.1:
		Direction = -1
		Speed += Acceleration * delta
	else:
		Speed = lerp(Speed, 0.0, 0.05)

	#max speed
	Speed = clamp(Speed, 0.0, Max_Speed)
	
	var speed_ratio = Speed / Max_Speed
	Turn_Speed = pow(speed_ratio, Turn_Response_Curve) * Max_Turn_Speed
	Turn_Speed = clamp(Turn_Speed, 0.0, Max_Turn_Speed)
	
	if abs(Speed) > 0.1:
		rotation.y += Steer_Angle * Turn_Speed * delta * Direction

	
	Forward_Direction = -transform.basis.z
	velocity.x = Forward_Direction.x * Speed * Direction
	velocity.z = Forward_Direction.z * Speed * Direction

	
	move_and_slide()

	
	Front_Wheel_Left.rotation.y = Steer_Angle / 2
	Front_Wheel_Right.rotation.y = Steer_Angle / 2
