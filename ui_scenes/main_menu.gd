extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()

func _on_start_button_pressed():
	SceneTransition.wipe_to_scene("res://ui_scenes/level_select/level_select.tscn")
	$AudioStreamPlayer.stop()

func _on_quit_button_pressed():
	get_tree().quit()
