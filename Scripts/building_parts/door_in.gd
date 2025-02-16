extends Node3D

var player: CharacterBody3D
var initial_player_position

@onready var data = Props.new()

func _ready() -> void:
	data._name = "door_out"

func _process(delta: float) -> void:
	if player:
		var keys:Array = player.data.keys
		if Input.get_action_strength("interact"):
			
				if not initial_player_position:
					initial_player_position = player.global_position
					
				player.body.opening_door = true
				player.global_position.x = $pivot_enter.global_position.x
				player.global_position.z = $pivot_enter.global_position.z
				
				var direction = Vector3.ZERO
				direction.x = -1 if $pivot_leave.global_position.x <  $pivot_enter.global_position.x else 1
				direction.z = -1 if $pivot_leave.global_position.z <  $pivot_enter.global_position.z else 1
				
				player.body_container.look_at(-$pivot_look_at.global_position)
				player.body_container.rotation.x = 0
				player.body_container.rotation.z = 0
				
				if len(keys) > 0:
					$AnimationPlayer.play("open")
					await get_tree().create_timer(3).timeout
					create_tween().tween_property(player, "global_position", $pivot_leave.global_position, 2)
					create_tween().tween_property(player, "global_position", $pivot_leave.global_position, 2)
					player.global_position.y = initial_player_position.y
				else:
					player.body.opening_door = true
					player.body.locked_door = true
					await get_tree().create_timer(5.3).timeout
					player.body.locked_door = false
					player.body.opening_door = false
			

func _on_area_3d_body_entered(body: Node3D) -> void:
	player = body
	player.interactable_entered.emit(self)

func _on_area_3d_body_exited(body: Node3D) -> void:
	player.interactable_exited.emit(self)
	player = null

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "open":
		player.body.opening_door = false
		
		player.global_position.x = $pivot_leave.global_position.x
		player.global_position.z = $pivot_leave.global_position.z
