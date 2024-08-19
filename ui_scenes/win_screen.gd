extends Control

func _on_next_level_pressed() -> void:
	print("pressed")
	self.hide()
	get_tree().change_scene_to_file("res://ui_scenes/test_level.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _on_quit_pressed() -> void:
	get_tree().quit()
