extends Control

func _on_resume_pressed() -> void:
	self.hide()
	get_tree().paused = false

func _on_quit_pressed() -> void:
	get_tree().quit()
