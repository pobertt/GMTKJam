extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func wipe_to_scene(scene_path: String):
	animation_player.play("wipe_in")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(scene_path)
	animation_player.play("wipe_out")
