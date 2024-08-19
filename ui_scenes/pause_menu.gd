extends Control

func _on_resume_pressed() -> void:
	self.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false

func _on_quit_pressed() -> void:
	get_tree().quit()
