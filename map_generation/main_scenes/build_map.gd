extends Node2D

# Level info
@export var level_info: LevelInfo

var block_list : Array[BlockBuildInfo]
@export var block_types: Array[BlockType]

# tool vars
enum Tools{EMPTY, FLOOR, WALL}
var active_tool: Tools
var is_active_tool := false

var start_coord := Vector2i(12,5) # only need active area of tilemap
var end_coord := Vector2i(24,13)

var block_buttons : Array[BlockButton]

# onready vars
@onready var tile_map: TileMapLayer = $tile_map
@onready var simultaneous_scene = preload("res://map_generation/main_scenes/GeneratedLevel.tscn").instantiate()
@onready var block_container: VBoxContainer = $ui/block_container
@onready var build_sprite: Sprite2D = $build_sprite
@onready var try_button: Button = $ui/VBoxContainer/try_button
@onready var reset_button: Button = $ui/VBoxContainer/reset_button

const generated_level_scene = preload("res://map_generation/main_scenes/GeneratedLevel.tscn")
const block_button = preload("res://map_generation/ui/block_button.tscn")
const block_sprite = preload("res://map_generation/2d_sprites/TestSpritetscn.tscn")


func _ready() -> void:
	set_up_level()

func set_up_level() -> void:
	if level_info:
		for block in level_info.blocks: # create a block button for each block type in level resource
			var button = block_button.instantiate() as BlockButton
			button.block_type = block.block_type
			button.amount = block.amount
			button.spawn_block.connect(activate_block_tool)
			block_buttons.append(button)
			block_container.add_child(button)

func activate_block_tool(type: BlockType):
	#print(type._name)
	#var new_block = block_sprite.instantiate() as BlockSprite
	#block_container.add_child(new_block)
	#new_block._set_sprite(type)
	#new_block._set_tile_map_ref(tile_map)
	#new_block.set_process(true)
	
	if type:
		build_sprite.texture = build_sprite.texture.duplicate()
		match type._name:
			"Floor":
				active_tool = Tools.FLOOR
				build_sprite.texture.region = Rect2(Vector2(0,0), Vector2(32,32))
			"Wall":
				active_tool = Tools.WALL
				build_sprite.texture.region = Rect2(Vector2(32,0), Vector2(32,32))
		
		build_sprite.show()
		is_active_tool = true
		
		# make buttons inactive to prevent losing tiles
		set_block_button_enabled(false)

func _process(delta: float) -> void:
	if is_active_tool != null:
		var mouse_pos = get_global_mouse_position()
		
		var tile_pos = tile_map.local_to_map(tile_map.to_local(mouse_pos)) # convert mouse pos to tilemap coord
		
		var snapped_pos = tile_map.to_global(tile_map.map_to_local(tile_pos)) # convert tilemap coords back to pos
		
		build_sprite.global_position = snapped_pos
		
		if is_valid_tile_pos(tile_pos): # change colour for player feedback if can place here or not
			build_sprite.modulate = Color.WHITE
		else:
			build_sprite.modulate = Color.INDIAN_RED
		
		if Input.is_action_just_pressed("MovePiece"):
			if is_valid_tile_pos(tile_pos):
				match active_tool:
					Tools.FLOOR:
						tile_map.set_cell(tile_pos, 0, Vector2i(0,0))
					Tools.WALL:
						tile_map.set_cell(tile_pos, 0, Vector2i(1,0))
				
				build_sprite.hide()
				active_tool = Tools.EMPTY
				is_active_tool = false
				
				set_block_button_enabled(true)

func set_block_button_enabled(enabled: bool):
	for button in block_buttons:
		button.disabled = !enabled

func is_valid_tile_pos(coord: Vector2) -> bool:
	# check if pos is in defined area
	if coord.x < start_coord.x or coord.x > end_coord.x or \
	   coord.y < start_coord.y or coord.y > end_coord.y:
		return false
	
	if tile_map.get_cell_source_id(coord) != -1: # check if tile is already occupied
		return false
	
	return true

func generate_map():
	block_list.clear()
	
	for x in range(start_coord.x, end_coord.x + 1):
		for y in range(start_coord.y, end_coord.y + 1):
			var block = get_block_at_coord(Vector2i(x, y))
			if block:
				block_list.append(block)


# DEBUG -- GenerateMap Function
func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		generate_map()



# gets block resource at coordinate based on texture position on atlas texture
func get_block_at_coord(coord: Vector2i) -> BlockBuildInfo:
	var atlas_coords = tile_map.get_cell_atlas_coords(coord)
	
	var block_data = BlockBuildInfo.new()
	
	block_data.coordinates = coord
	
	match atlas_coords: # set the block type based off tilemap atlas coords
		Vector2i(0,0):
			block_data.block_type = block_types[0]
		Vector2i(1,0):
			block_data.block_type = block_types[3]
		Vector2i(2,0):
			block_data.block_type = block_types[2]
		Vector2i(3,0):
			block_data.block_type = block_types[1]
	
	if block_data.block_type:
		return block_data
	else:
		return null


func _on_button_pressed():
	generate_map()
	var level = generated_level_scene.instantiate() as GeneratedLevel # passes map info directly
	level.block_list = block_list
	get_tree().root.add_child(level)
	queue_free()
	pass

func _reload_button_pressed():
	get_tree().reload_current_scene()
	pass # Replace with function body.
