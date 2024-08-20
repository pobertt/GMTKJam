extends Control

# onready vars
@onready var level_resource_preloader: ResourcePreloader = $level_resource_preloader
@onready var level_container: HBoxContainer = $MarginContainer/CenterContainer/ScrollContainer/level_container


const level_button_scene = preload("res://ui_scenes/level_select/level_button_container.tscn")

func _ready() -> void:
	var top := false
	for level_name in level_resource_preloader.get_resource_list():
		var level = level_resource_preloader.get_resource(level_name)
		var button = level_button_scene.instantiate() as LevelButtonContainer
		level_container.add_child(button)
		button.set_up_button(level, top)
		top = !top


func _on_menu_button_pressed() -> void:
	SceneTransition.wipe_to_scene("res://ui_scenes/MainMenu.tscn")
