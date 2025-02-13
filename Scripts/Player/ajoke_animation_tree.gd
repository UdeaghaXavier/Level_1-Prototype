extends Node3D

@export var anim_tree:AnimationTree
@onready var anim:AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")
var last_input_dir = Vector3.ZERO
var input_dir = Vector2.ZERO
var opening_door = false
var can_sit = false
var stand = true

func _ready() -> void:
	anim_tree.active = true
	
func change_anim_state_to(anim:String):
	var prefix = "parameters/conditions/"
	var states = ["idle", "walk", "door", "sit"]
	
	for state in states:
		var cond = false
		if state == anim:
			cond = true
			
			if state == "walk":
				anim_tree.set("parameters/walk/blend_position", input_dir)
			elif state == "sit":
				var speed_parameter = "parameters/playback_speed"
				if can_sit and not stand: # initially sitting
					anim_tree[speed_parameter] = -1
				elif can_sit and stand:
					anim_tree[speed_parameter] = 1
			
		anim_tree[prefix+state] = cond
func _physics_process(delta: float) -> void:
	input_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_dir.y = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	
func anim_handler():
	if not Input.get_action_strength("interact") :
		if input_dir == Vector2.ZERO:
			change_anim_state_to("idle")
		else:
			if Input.get_action_raw_strength("run"):
				change_anim_state_to("run")
			else:
				change_anim_state_to("walk")
	else:
		if opening_door:
			change_anim_state_to("door")
		elif can_sit:
			change_anim_state_to("sit")
		
	last_input_dir = input_dir
