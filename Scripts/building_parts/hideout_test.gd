extends Node3D

@export var elevator:Node3D
var elevator_start_pos = Vector3.ZERO

func _ready() -> void:
	elevator_start_pos = elevator.global_position
	elevator.player_ready_to_descend.connect(move_elevator)

func move_elevator():
	if elevator_start_pos != elevator.global_position:
		$"Second Floor/AnimationPlayer".play_backwards("descend_elevator")
	else:
		$"Second Floor/AnimationPlayer".play("descend_elevator")
