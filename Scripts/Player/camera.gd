extends Node3D

@export var pivot:Node3D
@export var sens = 0.5

func _ready() -> void:
	%Camera.position.z = %SpringArm.spring_length
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion:
		pivot.rotate_y(deg_to_rad(event.relative.x * -sens))
		rotate_x(deg_to_rad(event.relative.y * sens))
		rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(45))
