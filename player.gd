extends CharacterBody3D

var speed
const WALK_SPEED = 4.0
const SPRINT_SPEED = 8.0
const SLIDE_SPEED = 15
var JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.007

# Bob variables.
const BOB_FREQ = 2.0
const BOB_AMP = 0.05
var t_bob = 0.0

# FOV variables.
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

var jump_count : int = 0
@export var jumps : int = 1

var crouching : bool = false
var sprinting : bool = false
var sliding : bool = false

var gravity_vec = Vector3( )

@onready var anim: AnimationPlayer = $AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head = $cam_controller
@onready var camera = $cam_controller/camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta):
	
	print(speed)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		jump_count = 0
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_count < jumps:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		
	# Handle Sprint.
	if Input.is_action_pressed("sprint") and crouching == false:
		speed = SPRINT_SPEED
		sprinting = true
	else:
		speed = WALK_SPEED
		sprinting = false
		
	if Input.is_action_just_pressed("slide"):
		anim.play("slide")

		sliding = true
	if Input.is_action_pressed("slide") and is_on_floor():
		speed = SLIDE_SPEED
		JUMP_VELOCITY = 9
	if Input.is_action_just_released("slide"):
		anim.play_backwards("slide")

		speed = WALK_SPEED
		JUMP_VELOCITY = 4.5
	
		
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.x * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
			
	# Head Bob.
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	#FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()
	
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
