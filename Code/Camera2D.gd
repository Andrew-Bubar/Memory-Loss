extends Camera2D


func _on_Player_grounded_changed(is_grounded):
	drag_margin_v_enabled = !is_grounded
