extends Node2D

var tile;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tile = $TileMapLayer.local_to_map(get_global_mouse_position());
	$TileMapLayer.set_cell(tile, 0, Vector2i(0, 0), 0);
	
		
	
	#pass
