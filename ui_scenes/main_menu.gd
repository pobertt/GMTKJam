extends Control


func _on_start_button_pressed():
	SceneTransition.wipe_to_scene("res://ui_scenes/level_select/level_select.tscn")

func _on_quit_button_pressed():
	get_tree().quit()


func _on_toggle_music_toggled(toggled_on: bool) -> void:
	Autoload.bg_music.playing = !toggled_on
