extends Node3D

var player:CharacterBody3D
@export var object:Node3D
var use_count = 0

func _physics_process(delta: float) -> void:
	if player and use_count == 0:
		if Input.is_action_just_pressed("interact"):
			if object:
				if object.state == "closed":
					object.state = "open"
					object.get_node("AnimationPlayer").play("open")
					$AnimationPlayer.play("on")
				elif object.state == "open":
					object.state = "closed"
					object.get_node("AnimationPlayer").play_backwards("open")
					$AnimationPlayer.play_backwards("on")
				use_count += 1
func _on_player_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body


func _on_player_detector_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = null
		use_count = 0
