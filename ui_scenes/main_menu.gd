extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://ui_scenes/test_level.tscn")
	$AudioStreamPlayer.stop()
	pass
	
func _on_quit_button_pressed():
	get_tree().quit()
