extends Control

var message:String = ""
var prop_node:Node3D = null

func _process(delta: float) -> void:
	if prop_node:
		$CanvasLayer/Label.show()
		$CanvasLayer/Label.text = get_message()
	else:
		$CanvasLayer/Label.hide()
		$CanvasLayer/Label.text = ""

func get_message():
	var n = prop_node.data._name
	
	if n == "door":
		return "Press \"E\" to Open the door"
	elif n == "door_out":
		if len(Global.player.data.keys) > 0:
			return "Press \"E\" to Open the door"
		else:
			return "This door is locked, Find a Key"
	elif n == "lever":
		return "Press \"E\" to pull the lever"
	elif n == "box":
		return "Press \"E\" to move the box"
	elif n == "chair":
		return "Press \"E\" to sit"
	elif n == "key":
		return "Press \"E\" to pick up key" 
	elif n == "vent":
		return "This is a vent, press \"C\" to crouch then \"Shift\" to crawl"

func _on_ajoke_interactable_entered(prop) -> void:
	prop_node = prop 

func _on_ajoke_interactable_exited(prop) -> void:
	prop_node = null
