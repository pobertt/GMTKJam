extends Node3D

@export var MapGenResource : Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_dress_level()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _set_dress_level():
	for item in MapGenResource.buildingcoords:
		$GridMap.set_cell_item(Vector3i(item.x, 0, item.y), MapGenResource.buildingcoords.get(item), 0)
		print($GridMap.get_cell_item(Vector3i(item.x, 0, item.y)))
	pass
