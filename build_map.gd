extends Node2D

#@onready var tilemap = get_node("Map")
@onready var simultaneous_scene = preload("res://GeneratedLevel/GeneratedLevel.tscn").instantiate()
@export var MapGenResource : Resource
var Sprites = []
var BuildingCoords_Dict = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	for x in $Node2D.get_children():
		Sprites.append(x)
	pass # Replace with function body.
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _GenerateMap():
	MapGenResource.buildingcoords.clear()
	for x in Sprites:
		MapGenResource.buildingcoords.get_or_add(x.mouse_tile, x._mesh_library_index)
	#print(BuildingCoords_Dict)
	
func _GetBuildingCoords():
	return MapGenResource.buildingcoords
	
# DEBUG -- GenerateMap Function
func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		_GenerateMap()
		
		
func _on_button_pressed():
	_GenerateMap()
	get_tree().change_scene_to_file("res://GeneratedLevel/GeneratedLevel.tscn")
	pass
	
	


func _reload_button_pressed():
	get_tree().reload_current_scene()
	pass # Replace with function body.
