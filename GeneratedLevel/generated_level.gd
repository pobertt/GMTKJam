extends Node3D

@export var MapGenResource : Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_dress_level()
	$GridMap.set_cell_item(Vector3i(MapGenResource.PlayerStart.x, 0, MapGenResource.PlayerStart.y), 2, 0)
	$GridMap.set_cell_item(Vector3i(MapGenResource.PlayerEnd.x, 0, MapGenResource.PlayerEnd.y), 0, 0)
	$player.global_position = $".".to_global($GridMap.map_to_local($GridMap.get_used_cells_by_item(2)[0])) + Vector3(0,5,0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _set_dress_level():
	for item in MapGenResource.buildingcoords:
		$GridMap.set_cell_item(Vector3i(item.x, 0, item.y), MapGenResource.buildingcoords.get(item), 0)
		print($GridMap.get_cell_item(Vector3i(item.x, 0, item.y)))
	pass
