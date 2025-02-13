extends Node3D

@export var anim_tree:AnimationTree
@onready var anim:AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")
var last_input_dir = Vector3.ZERO
var input_dir = Vector2.ZERO
var opening_door = false
var sit_state = 0 # idle = 0, stand = 1, sit = 2

func _ready() -> void:
	anim_tree.active = true
	
func change_anim_state_to(anim:String):
	var prefix = "parameters/conditions/"
	var states = ["idle", "walk", "door", "sit"]
	var speed_parameter = "parameters/sit/TimeScale/scale"
	
	for state in states:
		var cond = false
		if state == anim:
			cond = true
			
			if state == "walk":
				anim_tree.set("parameters/walk/blend_position", input_dir)
		
		# idle = 0, stand = 1, sit = 2
		if sit_state == 2: # sitting
			anim_tree[speed_parameter] = -1
		elif sit_state == 1: # standing
			anim_tree[speed_parameter] = 1
			
		anim_tree[prefix+state] = cond
		
		
func is_sitting():
	return sit_state != 0
		
func _physics_process(delta: float) -> void:
	input_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_dir.y = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	
func anim_handler():
	if opening_door:
		change_anim_state_to("door")
	elif sit_state != 0:
		change_anim_state_to("sit")
	elif input_dir == Vector2.ZERO:
		change_anim_state_to("idle")
	else:
		if Input.get_action_raw_strength("run"):
			change_anim_state_to("run")
		else:
			change_anim_state_to("walk")
		
	last_input_dir = input_dir
