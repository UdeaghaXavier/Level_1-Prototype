extends RigidBody3D

var player: CharacterBody3D

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		if Input.is_action_just_pressed("interact"):
			# player.get_node("CollisionShape3D").disabled = true
			player.global_position.x = $pivot.global_position.x
			player.global_position.z = $pivot.global_position.z
			player.body_container.look_at($face_pivot.global_position)
			player.body_container.rotation_degrees.y += -180
			player.body_container.rotation.x = 0
			player.body_container.rotation.z = 0
			
			if player.body.sit_state == 0:
				# Initialize sitting state
				player.body.sit_state = 1
				
			elif player.body.sit_state == 1:
			# Make player sit
				player.body.sit_state = 2
				
		
		# idle = 0, stand = 1, sit = 2

func _on_area_3d_body_entered(body: Node3D) -> void:
	player = body

func _on_area_3d_body_exited(body: Node3D) -> void:
	player.body.sit_state = 0
	player.get_node("CollisionShape3D").set_deferred("disabled", false)
	
	player = null
