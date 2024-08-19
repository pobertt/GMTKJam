extends Node3D
class_name GeneratedLevel

@export var block_list : Array[BlockBuildInfo]

# onready vars
@onready var grid_map: GridMap = $GridMap


func _ready():
	set_dress_level()

func set_dress_level():
	for block_info in block_list:
		var block = block_info.block_type.packed_scene.instantiate()
		
		var grid_pos = Vector3(block_info.coordinates.x, 0.0, block_info.coordinates.y)
		grid_pos -= Vector3(13,0,9) # account for tilemap offset
		var world_position = grid_map.map_to_local(grid_pos)
		
		grid_map.add_child(block)
		
		block.global_transform.origin = world_position - Vector3(0,1,0)
		block.scale = Vector3(2,2,2) # correcting wrong sized scenes HACKY
		
		print("Instantiated block: ", block_info.block_type._name, " at ", grid_pos)
