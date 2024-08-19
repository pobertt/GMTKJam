extends AnimatedSprite2D
class_name BlockSprite

@export var _mesh_library_index : int = 0
var local_pos
var mouse_tile
var move_this_piece = false
var can_grab = true;
var tile_map
@export var block_types: Array[BlockType]
var block_sprite

func _ready():
	set_process(false)
	block_sprite = $"."
	#tile_map = get_node("tile_map")
	pass


func _process(_delta):
	if (Input.is_action_pressed("MovePiece") && move_this_piece == true):
		mouse_tile = tile_map.local_to_map(get_global_mouse_position())
		print(mouse_tile)
		local_pos = tile_map.map_to_local(mouse_tile)
		if (tile_map.get_used_rect().has_point(mouse_tile)):
			global_position = local_pos
			can_grab = true;
	elif (Input.is_action_just_released("MovePiece") && move_this_piece):
		move_this_piece = false
		set_process(false)
		#tile_map.set_cell(tempMouseTile, -1)
	#if (tile_map.get_cell_source_id(tempMouseTile) != 0 && tile_map.get_used_rect().has_point(tempMouseTile)):
		#can_grab = false
	#else:
		#can_grab = true
	pass


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#if tile_map.get_used_rect().has_point(to_local(event.position)) && can_grab:
		move_this_piece = true
	pass
			

# Change sprite (Anim Frame) according to Block type spawned from UI
func _set_sprite(type: BlockType):
	#match type:
		#block_types[0]: # floor
			#block_sprite.frame = 0
		#block_types[1]: # wall
			#block_sprite.frame = 1
	if (type == block_types[0]):  
		block_sprite.frame = 0
	elif (type == block_types[1]):
		block_sprite.frame = 1
	pass
	
func _set_tile_map_ref(map: TileMapLayer):
	tile_map = map
