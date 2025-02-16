extends Node3D

var player:CharacterBody3D
@export var object:Node3D
@onready var data = Props.new()

var use_count = 0

func _ready() -> void:
	data._name = "lever"

func _physics_process(delta: float) -> void:
	if player and use_count == 0:
		if Input.is_action_just_pressed("interact"):
			if object:
				object.state = "open"
				object.get_node("AnimationPlayer").play("open")
				$AnimationPlayer.play("on")
				use_count += 1
func _on_player_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		player.interactable_entered.emit(self)

func _on_player_detector_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player.interactable_exited.emit(self)
		player = null
		use_count = 0
