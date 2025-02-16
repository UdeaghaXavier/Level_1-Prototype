extends Node3D

@export var elevator:Node3D
var elevator_start_pos = Vector3.ZERO
@onready var anim_player = $"Second Floor/AnimationPlayer"

func _ready() -> void:
	elevator_start_pos = elevator.global_position
	elevator.player_ready_to_descend.connect(move_elevator)

func move_elevator():
	if $"Second Floor/AnimPlayerDelay".is_stopped():
		if elevator_start_pos != elevator.global_position:
			anim_player.play_backwards("descend_elevator")
		else:
			anim_player.play("descend_elevator")
		$"Second Floor/AnimPlayerDelay".start()
