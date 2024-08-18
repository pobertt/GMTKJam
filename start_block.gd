extends Node3D

@export var player_scene : PackedScene 
@onready var player: CharacterBody3D = $player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var index = 0

	for spawn in get_tree().get_nodes_in_group("spawn_pos"):
		player.global_position = spawn.global_position
		index += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
