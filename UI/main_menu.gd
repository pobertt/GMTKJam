extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	#BuildMap.get_node("/root/BuildMap").hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_button_pressed():
	get_tree().change_scene_to_file("res://build_map.tscn")
	pass
