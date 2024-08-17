extends Sprite2D

@export var _name = ""
var local_pos
var mouse_tile
var move_this_piece = false

# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (Input.is_action_pressed("MovePiece") && move_this_piece == true):
		mouse_tile = BuildMap.tilemap.local_to_map(get_global_mouse_position())
		local_pos = BuildMap.tilemap.map_to_local(mouse_tile)
		if (BuildMap.tilemap.get_used_rect().has_point(mouse_tile) && BuildMap.tilemap.get_cell_source_id(mouse_tile) != 1):
			global_position = local_pos
	elif (Input.is_action_just_released("MovePiece")):
		move_this_piece = false
	#pass


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):
			move_this_piece = true
			
