extends Node2D


@onready var tilemap = get_node("Map")
var Sprites = []
var BuildingCoords_Dict = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	for x in $Node2D.get_children():
		Sprites.append(x)

	#pass # Replace with function body.
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _GenerateMap():
	BuildingCoords_Dict.clear()
	for x in Sprites:
		BuildingCoords_Dict.get_or_add(x.mouse_tile, x._name)
	print(BuildingCoords_Dict)
	
func _GetBuildingCoords():
	return BuildingCoords_Dict
	
# DEBUG -- GenerateMap Function
func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		_GenerateMap()
