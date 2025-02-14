extends CharacterBody3D

var is_pushing = false
var pusher:CharacterBody3D = null

const pivot_distance = 1.2

func _ready() -> void:
	for pivot in $Pivots.get_children():
		if pivot.position.x != 0:
			pivot.position.x = pivot_distance * (-1 if pivot.position.x < 0 else 1)
		if pivot.position.z != 0:
			pivot.position.z = pivot_distance * (-1 if pivot.position.z < 0 else 1)

func get_closest_pivot():
	var closest_pivot = $Pivots.get_child(0)
	var shortest_distance = Vector3(10000, 0, 10000)
	
	var i = 0
	for pivot in $Pivots.get_children():
		var distance = Vector3.ZERO
		distance = abs(pusher.global_position  - pivot.global_position)
		
		if distance.x < shortest_distance.x and distance.z < shortest_distance.z:
			shortest_distance = distance
			closest_pivot = pivot
			
		i += 1
	return closest_pivot
		
func _physics_process(delta: float) -> void:
	if not is_pushing:
		if not pusher:
			velocity = Vector3.ZERO
	else:
		if pusher:
			var closest_pivot = get_closest_pivot()
			velocity = pusher.velocity
			pusher.body_container.look_at($Pivots.global_position)
			pusher.body_container.rotation.x = 0
			pusher.body_container.rotation.z = 0
			pusher.body_container.rotation_degrees.y += 180
			pusher.global_position.x = closest_pivot.global_position.x
			pusher.global_position.z = closest_pivot.global_position.z
	
	move_and_slide()
