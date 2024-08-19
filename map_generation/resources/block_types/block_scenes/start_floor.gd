extends Node3D

func _ready() -> void:
	var generated_level = get_parent().get_parent() as GeneratedLevel
	generated_level.player.global_transform.origin = $spawn_pos.global_transform.origin
