extends Node3D

var player: CharacterBody3D
var initial_player_position

func _process(delta: float) -> void:
	if player:
		if Input.get_action_strength("interact"):
			if not initial_player_position:
				initial_player_position = player.global_position
				
			player.body.opening_door = true
			player.global_position.x = $pivot_enter.global_position.x
			player.global_position.z = $pivot_enter.global_position.z
			
			var direction = Vector3.ZERO
			direction.x = -1 if $pivot_leave.global_position.x <  $pivot_enter.global_position.x else 1
			direction.z = -1 if $pivot_leave.global_position.z <  $pivot_enter.global_position.z else 1
			
			player.body_container.look_at( (direction.x) * $pivot_look_at.global_position)
			player.body_container.rotation_degrees.y += 180
			player.body_container.rotation.x = 0
			player.body_container.rotation.z = 0
			
			$AnimationPlayer.play("open")
			await get_tree().create_timer(3).timeout
			if player:
				create_tween().tween_property(player, "global_position", $pivot_leave.global_position, 2)
				create_tween().tween_property(player, "global_position", $pivot_leave.global_position, 2)
				player.global_position.y = initial_player_position.y
			

func _on_area_3d_body_entered(body: Node3D) -> void:
	player = body

func _on_area_3d_body_exited(body: Node3D) -> void:
	player = null

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "open":
		player.body.opening_door = false
		
		player.global_position.x = $pivot_leave.global_position.x
		player.global_position.z = $pivot_leave.global_position.z
