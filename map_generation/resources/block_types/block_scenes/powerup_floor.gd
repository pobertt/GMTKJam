extends Node3D

@onready var coin_mesh = $mesh2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _collected():
	coin_mesh.hide()

	
func _respawn():
	coin_mesh.show()
