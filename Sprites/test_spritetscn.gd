extends Sprite2D

@export var _mesh_library_index : int = 0
var local_pos
var mouse_tile
var move_this_piece = false
var can_grab = true;


# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var tempMouseTile = $"../../Map".local_to_map(get_global_mouse_position())
	if (Input.is_action_pressed("MovePiece") && move_this_piece == true):
		mouse_tile = $"../../Map".local_to_map(get_global_mouse_position())
		local_pos = $"../../Map".map_to_local(mouse_tile)
		if ($"../../Map".get_used_rect().has_point(mouse_tile) && $"../../Map".get_cell_source_id(mouse_tile) == 0):
			global_position = local_pos
			can_grab = true;
	elif (Input.is_action_just_released("MovePiece") && move_this_piece):
		move_this_piece = false
		$"../../Map".set_cell(tempMouseTile, -1)
	if ($"../../Map".get_cell_source_id(tempMouseTile) != 0 && $"../../Map".get_used_rect().has_point(tempMouseTile)):
		can_grab = false
	else:
		can_grab = true

	#pass


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)) && can_grab:
			move_this_piece = true
			
