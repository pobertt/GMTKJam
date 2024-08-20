extends VBoxContainer
class_name LevelButtonContainer

var unlocked: bool = false
var active_level: LevelInfo

var green_tex = preload("res://assets/textures/ui/unlocked_level.png")
var green_selected_tex = preload("res://assets/textures/ui/unlocked_level_selected.png")
var red_tex = preload("res://assets/textures/ui/locked_level.png")

# onready vars
@onready var level_button: TextureButton = $level_button
@onready var number_label: Label = $level_button/number_label
@onready var empty: TextureRect = $empty

func set_up_button(level: LevelInfo, top: bool):
	if top: # set empty to either top or bottom to have fancy level select screen
		move_child(empty, get_child_count())
	else:
		move_child(empty, 0)
	
	active_level = level
	
	if Autoload.levels_complete >= level.number: # set to green block when level is unlocked
		unlocked = true
		
		level_button.texture_normal = green_selected_tex
		level_button.texture_hover = green_tex
		level_button.texture_pressed = green_selected_tex
	else:
		level_button.texture_normal = red_tex
	
	number_label.text = str(level.number)

func _on_level_button_pressed() -> void:
	if unlocked:
		print(str("opening level ", active_level.number))
		SceneTransition.wipe_to_scene("res://map_generation/main_scenes/build_map.tscn")
		Autoload.active_level = active_level
	else:
		print("level locked")
