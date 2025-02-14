extends Node3D

@export var anim_tree:AnimationTree
@onready var state_machine:AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")
var input_dir = Vector2.ZERO
var sit_state = 0 # idle = 0, stand = 1, sit = 2
var pick_up_state = 0 # 0 - nothing to pick up, 1 - is picking it up, 2 - picked it up

var opening_door = false
var crouching = false
var crawling = false
var pushing = false

func _ready() -> void:
	anim_tree.active = true
	state_machine.start("idle")
func change_anim_state_to(anim:String):
	var prefix = "parameters/conditions/"
	var states = ["idle", "walk", "door", "sit"]
	var speed_parameter = "parameters/sit/TimeScale/scale"
	
	for state in states:
		var cond = false
		if state == anim:
			cond = true
	
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
	
	if not crouching:
		crawling = false
	
	if not pushing or opening_door:
		if pick_up_state > 0:
			if pick_up_state == 1 and Input.get_action_strength("interact"):
				if $animation_delay.is_stopped():
					$animation_delay.start()
					pick_up_state = 2
	
func play_anim(anim):
	change_anim_state_to("") # Reset what the change anim_state did
	state_machine.travel(anim)
	
func anim_handler():
	if opening_door:
		play_anim("door")
	elif sit_state != 0:
		change_anim_state_to("sit")
	elif crouching:
		if not crawling:
			if input_dir == Vector2.ZERO:
				state_machine.travel("crouch_idle")
			else:
				state_machine.travel("crouch_walk")
		else:
			if input_dir == Vector2.ZERO:
				state_machine.travel("crawl_idle")
			else:
				state_machine.travel("crawl_walk")
	elif pick_up_state == 2:
		state_machine.travel("pickup")
		if $animation_delay.is_stopped():
			pick_up_state = 0
	elif pushing:
		if input_dir.y >= 0:
			state_machine.travel("push")
		elif input_dir.y < 0:
			state_machine.travel("pull")
	elif input_dir == Vector2.ZERO:
		play_anim("idle")
	else:
		if Input.get_action_raw_strength("run"):
			play_anim("run")
		else:
			play_anim("walk")
