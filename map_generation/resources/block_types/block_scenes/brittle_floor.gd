extends Node3D

@onready var collision: CollisionShape3D = $StaticBody3D/collision
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area: Area3D = $area

func _on_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		begin_fade()

func begin_fade():
	animation_player.play("fade_out")
	await get_tree().create_timer(5.0).timeout
	animation_player.play("fade_in")

func disable_collision():
	collision.disabled = true
	area.monitoring = false

func enable_collision():
	collision.disabled = false
	area.monitoring = true
