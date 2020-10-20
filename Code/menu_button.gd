extends Button

export (String) var scene_to_load

func _on_Start_pressed():
	if scene_to_load != null:
		get_tree().change_scene(scene_to_load)
	elif scene_to_load == "quit":
		get_tree().quit()
	else:
		print("scene not entered")


func _on_Exit_pressed():
	get_tree().quit()


func _on_TitleScreen_ready():
	grab_focus()
