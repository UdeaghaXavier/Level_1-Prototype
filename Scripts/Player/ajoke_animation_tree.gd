extends Node3D

@export var anim_tree:AnimationTree
@onready var anim:AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")


func _ready() -> void:
	anim_tree.active = true

func _process(delta: float) -> void:
	anim_handler(Vector3.ZERO)
	
func anim_handler(velocity:Vector3):
	if velocity == Vector3.ZERO:
		anim.travel("idle")
	else:
		anim.travel("run_inside")
