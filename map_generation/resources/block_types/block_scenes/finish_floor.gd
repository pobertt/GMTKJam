extends Node3D

func _on_finish_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		SceneTransition.wipe_to_scene("res://ui_scenes/win_screen.tscn")
		await get_tree().create_timer(0.4).timeout
		get_parent().get_parent().queue_free()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
