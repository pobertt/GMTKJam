extends Button
class_name BlockButton

signal spawn_block(type: BlockType)

var block_type: BlockType
var amount: int

func _ready() -> void:
	text = str("x", amount)
	
	icon = icon.duplicate()
	
	var tex_size = Vector2(32,32)
	match block_type._name:
		"Floor":
			icon.region = Rect2(Vector2(0,0), tex_size)
		"Wall":
			icon.region = Rect2(Vector2(32,0), tex_size)
		"Start Floor":
			icon.region = Rect2(Vector2(64,0), tex_size)
		"Finish Floor":
			icon.region = Rect2(Vector2(96,0), tex_size)

func _on_pressed() -> void:
	if amount >= 1:
		amount -= 1
		spawn_block.emit(block_type)
		
		text = str("x", amount)
	else:
		print("not enough blocks")
