extends Button
class_name BlockButton

signal spawn_block(type: BlockType)

var block_type: BlockType
var amount: int

# onready vars
@onready var number_label: Label = $number_label
@onready var description_label: Label = $description_label

func _ready() -> void:
	number_label.text = str("x", amount)
	description_label.text = block_type.description
	
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
		"Brittle Floor":
			icon.region = Rect2(Vector2(0,64), tex_size)
		"Ice Floor":
			icon.region = Rect2(Vector2(0,96), tex_size)
		"Launch Floor":
			icon.region = Rect2(Vector2(96,32), tex_size)
		"Powerup Floor":
			icon.region = Rect2(Vector2(0,32), tex_size)
		"Wall Jump Wall":
			icon.region = Rect2(Vector2(32,32), tex_size)
		
	
	#tooltip_text = block_type.description

func _on_pressed() -> void:
	if amount >= 1:
		amount -= 1
		spawn_block.emit(block_type)
		
		number_label.text = str("x", amount)
	else:
		print("not enough blocks")
