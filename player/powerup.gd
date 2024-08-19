extends Area3D

enum Type {
	dash,
	double_jump,
	small_powerup,
	win
}

@export var type := Type.dash
@export var active:bool
@export var sfx:AudioStreamPlayer3D 

@onready var mesh: MeshInstance3D = $mesh
@onready var label: Label3D = $mesh/label
@onready var respawn_timer: Timer = $respawn

var collectable = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mat = StandardMaterial3D.new()
	if type == Type.dash:
		label.text = "Dash"
		mat.set_albedo(Color(0,1,0,1))
	elif type == Type.double_jump:
		label.text = "Double Jump"
		mat.set_albedo(Color(1,0,0,1))
	elif type == Type.small_powerup:
		label.text = "Small Man syndrome"
		mat.set_albedo(Color(1,0,1,1))
	elif type == Type.win:
		label.text = "WIN"
		mat.set_albedo(Color(1,1,0,1))
			
	mesh.set_surface_override_material(0,mat)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mesh.rotation.y += 1 * delta


func _on_body_entered(body: Node3D) -> void:
	if type == Type.dash:
		body._gain_dash(active)
		sfx.play()
	elif type == Type.double_jump:
		body._gain_jumps(active)
		sfx.play()
	elif type == Type.small_powerup:
		body._small_powerup(active)
		sfx = $small_powerup_pickup
		sfx.play()
	elif type == Type.win:
		body._win()
		sfx.play()
		
	mesh.visible = false
	respawn_timer.start()


func _on_respawn_timeout() -> void:
	collectable = true
	mesh.visible = true
