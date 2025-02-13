extends RigidBody3D

var player: CharacterBody3D

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		if Input.is_action_just_pressed("interact"):
			if not player.body.can_sit:
				player.body.can_sit = true
				player.body.stand = false
			else:
				player.body.can_sit = false
				player.body.stand = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	player = body

func _on_area_3d_body_exited(body: Node3D) -> void:
	player = null
