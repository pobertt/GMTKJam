extends Control

func _on_resume_pressed() -> void:
	self.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_retry_button_pressed() -> void:
	SceneTransition.wipe_to_scene("res://map_generation/main_scenes/build_map.tscn")
	get_tree().paused = false
	await get_tree().create_timer(0.4).timeout
	get_parent().get_parent().get_parent().queue_free() # disgusting im sorry


func _on_level_select_pressed() -> void:
	SceneTransition.wipe_to_scene("res://ui_scenes/level_select/level_select.tscn")
	get_tree().paused = false
	await get_tree().create_timer(0.4).timeout
	get_parent().get_parent().get_parent().queue_free() # disgusting im sorry
