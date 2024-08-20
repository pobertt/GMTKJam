extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_body_entered(body: Node3D) -> void:
	if (body.is_in_group("player")):
		body._player_on_ice()
		
func _on_body_exited(body: Node3D) -> void:
	if (body.is_in_group("player")):
		body._player_off_ice()
