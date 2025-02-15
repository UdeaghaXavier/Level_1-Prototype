extends CharacterBody3D

@onready var body_container = $Body
@onready var body = body_container.get_node("Body")

@onready var data:Player = preload("res://Resources/Player.tres")

const JUMP_VELOCITY = 4.5
var input_dir = Vector2.ZERO
const inertia = 100
var box = null
var temp_key = null

func update_collider():
	if body.crawling:
		$crawl.disabled = false
		$upright.disabled = true
	else:
		$crawl.disabled = true
		$upright.disabled = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if not body.opening_door and body.sit_state != 1:
		move()
		
	input_handler()
	update_collider()
	
	if body.pick_up_state == 2 and body.get_node("animation_delay").is_stopped():
		temp_key.hide()
	
	body.anim_handler()
	move_and_slide()
	
	if not body.pushing:
		update_look_direction()
	
func input_handler():
	input_dir.x = (Input.get_action_strength("right") - Input.get_action_strength("left"))
	input_dir.y = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	
	if Input.get_action_strength("crouch"):
		body.crouching = not body.crouching
	if body.crouching and Input.get_action_strength("run"):
		body.crawling = true
	if Input.is_action_just_pressed("interact") and box != null:
		body.pushing = not body.pushing
		box.is_pushing = body.pushing
	if Input.get_action_strength("interact") and temp_key:
		if data.keys.find(temp_key) < 0:
			data.keys.append(temp_key)
			body.pick_up_state = 1
		
func get_pivot_direction(pivot_node:Node3D):
	return (pivot_node.global_position - global_position).normalized()
	
func update_look_direction():
	var obj = body_container
	var target_node:Node3D = null
	var rot_spd = 1

	if input_dir.y < 0 and input_dir.x < 0: # back_left
		target_node = %Movement_Pivot/frwd_right
	elif input_dir.y < 0 and input_dir.x > 0: # back_right
		target_node = %Movement_Pivot/frwd_left
	elif input_dir.y > 0 and input_dir.x > 0: # Frwd_left
		target_node = %Movement_Pivot/back_right
	elif input_dir.y > 0 and input_dir.x < 0: # Frwd_right
		target_node = %Movement_Pivot/back_left
	elif input_dir.y < 0:
		target_node = %Movement_Pivot/frwd
	elif input_dir.y > 0:
		target_node = %Movement_Pivot/back
	elif input_dir.x < 0:
		target_node = %Movement_Pivot/right
	elif input_dir.x > 0:
		target_node = %Movement_Pivot/left
		
	if target_node:
		obj.look_at(rot_spd*target_node.global_transform.origin, Vector3.UP)
		obj.rotation.z = 0
		obj.rotation.x = obj.rotation.z
		
func get_move_direction():
	if input_dir.y > 0 and input_dir.x > 0:
		return get_pivot_direction(%Movement_Pivot/frwd_right) 
	elif input_dir.y > 0 and input_dir.x < 0:
		return get_pivot_direction(%Movement_Pivot/frwd_left) 
	elif input_dir.y < 0 and input_dir.x < 0:
		return get_pivot_direction(%Movement_Pivot/frwd_right) * -1
	elif input_dir.y < 0 and input_dir.x < 0:
		return get_pivot_direction(%Movement_Pivot/frwd_left) * -1
	elif input_dir.y != 0:
		return get_pivot_direction(%Movement_Pivot/frwd) * input_dir.y
	elif input_dir.x > 0:
		return get_pivot_direction(%Movement_Pivot/right)
	elif input_dir.x < 0:
		return get_pivot_direction(%Movement_Pivot/left)
		
	return Vector3.ZERO
		
func get_vel():
	var direction = get_move_direction()
	var vel = Vector3.ZERO
	
	var spd = data.walk_spd
	if body.crouching:
		spd = data.walk_spd / data.spd_mul
	elif Input.get_action_strength("run"):
		spd = data.walk_spd * data.spd_mul
	
	vel.x = direction.x * spd
	vel.y = velocity.y
	vel.z = direction.z * spd
	
	return vel
		
func move():
	if not body.pushing:
		velocity = get_vel()
	else:
		velocity = get_pivot_direction($Body/push_frwd) * input_dir.y

func _on_box_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("box"):
		box = body
		box.pusher = self
	elif body.is_in_group("key"):
		temp_key = body
		

func _on_box_detector_body_exited(body: Node3D) -> void:
	if body.is_in_group("box") and body == box:
		box.is_pushing = false
		box.pusher = null
		box = null
	elif body.is_in_group("key"):
		temp_key = null
