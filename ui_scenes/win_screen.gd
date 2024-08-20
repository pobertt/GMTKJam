extends Control

func _on_next_level_pressed() -> void:
	SceneTransition.wipe_to_scene("res://ui_scenes/level_select/level_select.tscn")
	Autoload.levels_complete += 1


func _on_quit_pressed() -> void:
	get_tree().quit()
