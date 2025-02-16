extends CharacterBody3D

var direction = Vector3.ZERO
var RNG:RandomNumberGenerator
var spd = 3
var FOV = 6.5

func _ready() -> void:
	$Move_delay.wait_time = 6
	RNG = RandomNumberGenerator.new()

func get_directional_vector(obj):
	return (obj.global_position - global_position).normalized()

func get_vel() -> Vector3:
	var vel = Vector3.ZERO
	var vectorHor = Vector3.ZERO
	var vector = Vector3.ZERO
	var vectorVer = Vector3.ZERO
	
	if not can_see_player():
		if direction.x:
			vectorHor = $Move_Pivot/right.global_position * direction.x
		if direction.z:
			vectorVer = $Move_Pivot/frwd.global_position * direction.z
		vector = vectorHor + vectorVer
		
	else:
		vector = get_directional_vector(Global.player)
	
	vector.y = 0
	rotate_model(vector)
	return vector.normalized()

func update_dir():
	direction.x = RNG.randi_range(-1, 1)
	direction.z = RNG.randi_range(-1, 1)
	if direction == Vector3.ZERO:
		update_dir()
	
func can_see_player():
	var vector_pointing_to_player = global_position.direction_to(Global.player.global_position)
	var facing_direction = -$enemy.global_transform.basis.z
	var distance_vector = global_position - Global.player.global_position
	
	var distance_apart = pow(distance_vector.x, 2) + pow(distance_vector.y, 2) + pow(distance_vector.z, 2)
	
	if vector_pointing_to_player.dot(facing_direction) > 0 and pow(distance_apart , 0.5) < FOV:
		return true
	
func _physics_process(delta: float) -> void:
	move()
	velocity = get_vel() * spd
	move_and_slide()

func rotate_model(pos):
	if can_see_player():
		$enemy.look_at(Global.player.global_transform.origin, Vector3.UP)
	else:
		$enemy.look_at(pos, Vector3.UP, true)
	$enemy.rotation.x = 0
	$enemy.rotation.z = 0
	
func move():
	if $Move_delay.is_stopped():
		update_dir()
		$Move_delay.start()
	
