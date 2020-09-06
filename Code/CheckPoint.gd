tool
extends Area2D

export var next_scene: PackedScene

func _get_configuration_warning() -> String:
	return "The property Next Level can't be empty" if not next_scene else ""


func teleport() -> void:
	print("Level Complete!")
	get_tree().change_scene_to(next_scene)


func _on_CheckBox_body_entered(body):
	teleport()
