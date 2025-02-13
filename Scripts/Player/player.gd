extends CharacterBody3D

@onready var body_container = $Body
@onready var body = body_container.get_node("Body")
const SPEED = 5.0
const JUMP_VELOCITY = 4.5



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if not body.opening_door:
		move()
	update_animation()
		
	body.anim_handler()
	move_and_slide()
	
func move():
	var input_dir = Vector2.ZERO
	input_dir.x = (Input.get_action_strength("right") - Input.get_action_strength("left")) * -1
	input_dir.y = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	
	if input_dir.y < 0:
		input_dir.y = 0
	
	if input_dir != Vector2.ZERO:
		# If moving make player mesh rotate with cam
		body_container.look_at(get_node("Pivot/Camera/SpringArm/Camera").global_position)
		# Make sure the mesh only rotates on the y-axis (left - right)
		body_container.global_position = global_position
		body_container.rotation.x = 0
		body_container.rotation.z = body_container.rotation.x
	
	# Using player mesh, get the direction to move in
	var direction : Vector3 = (body_container.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
	# move in that direction
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
func update_animation():
	pass
