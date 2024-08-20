extends CharacterBody3D

var speed
const WALK_SPEED = 8
const ICE_SPEED = 1.5
const SPRINT_SPEED = 8
const SLIDE_SPEED = 25
const DASH_SPEED = 25
const JUMP_VELOCITY = 9
const WALL_JUMP_VEL = 6
const LAUNCH_PLAYER_VEL = 22
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
var dash_count : int = 0
@export var dashs : int = 0
var still_ice : bool = false

var double_jump_active : bool = false
var wall_jump_active : bool = false
var dash_active : bool = false
var crouching : bool = false
var sprinting : bool = false
var sliding : bool = false
var walking : bool = false
var ice : bool = false

var gravity_vec = Vector3( )
var ice_vec = Vector3( )

enum state {FLOOR, WALL, AIR, ICE}

#const FLOOR = 0
#const WALL = 1
#const AIR = 2#const ICE = 3
var current_state := state.AIR
const WALL_FRICTION = 0
const testvar = 0

var small_active : bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head = $cam_controller
@onready var camera = $cam_controller/camera
@onready var cam_marker: Marker3D = $cam_controller/marker
@onready var footstep_audio: AudioStreamPlayer3D = $player_audios/footstep
@onready var pause_menu: Control = $pause_menu
@onready var small_timer: Timer = $small_powerup
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-75), deg_to_rad(75))		

func _physics_process(delta):
	#print(velocity)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		jump_count = 0
		
	_check_sprint()
	
	#if sprinting == true and is_on_floor():
		#anim.play("run_sound")
	#elif walking == true and is_on_floor():
		#anim.play("walk_sound")
	if current_state == state.ICE:
			velocity = ice_vec * ICE_SPEED
	elif is_on_floor():
		if 	_get_direction():
			velocity.x = _get_direction().x * speed
			velocity.z = _get_direction().z * speed
		else:
			velocity.x = lerp(velocity.x, 	_get_direction().x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, 	_get_direction().x * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, 	_get_direction().x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, 	_get_direction().z * speed, delta * 3.0)
			
	# Head Bob.
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	#FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	if sliding == true:
		velocity_clamped = clamp(velocity.length(), 0.5, SLIDE_SPEED * 2)
		target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
		camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	_check_dash()
	_check_jump()
	
	if small_active == true:	
		_check_slide("small_slide")
	else:
		_check_slide("slide")
		
	move_and_slide()
	_update_state()
	
	if current_state == state.WALL:
		jump_count = 0
		velocity.y *= WALL_FRICTION
	
func _get_direction() -> Vector3:
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	return direction
	
func _update_state():
	if is_on_wall_only() && wall_jump_active == true:
		current_state = state.WALL
	elif is_on_floor():
		if (ice == false):
			current_state = state.FLOOR
		else:
			current_state = state.ICE
	else:
		current_state = state.AIR
	
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	
func _check_jump():
	if Input.is_action_just_pressed("jump"):
		if double_jump_active == true:
			jumps = 2
		else:
			jumps = 1
			
		if jump_count < jumps:
			jump_count += 1
			$player_audios/jump.play()
			if current_state == state.FLOOR || current_state == state.ICE:
				velocity.y = JUMP_VELOCITY
			elif current_state == state.WALL:
				velocity = get_wall_normal() * WALL_JUMP_VEL#((camera.global_basis * Vector3.FORWARD) * WALL_JUMP_VEL)
				velocity.y += JUMP_VELOCITY 
			elif current_state == state.AIR:
				velocity.y = JUMP_VELOCITY
				double_jump_active = false
				print("double jump disabled")

func _check_slide(slide_type):
	if Input.is_action_just_pressed("slide"):
		anim.play(slide_type)
	if Input.is_action_pressed("slide"):
		if speed > 4 and is_on_floor():
			sliding = true
			speed = SLIDE_SPEED
			JUMP_VELOCITY * 1.5
	if Input.is_action_just_released("slide"):
		if sliding == true:
			anim.play_backwards(slide_type)
			speed = WALK_SPEED
			JUMP_VELOCITY * 1

func _check_sprint():
	if Input.is_action_pressed("sprint") and crouching == false:
		speed = SPRINT_SPEED
		sprinting = true
		walking = false
	else:
		speed = WALK_SPEED
		sprinting = false
		walking = true
		
func _gain_dash(active):
	if active == true:
		print("dash active")
		dash_active = active
	_powerup_ui("DASH powerup")

func _gain_jumps(active):
	if active == true:
		print("double jump active")
		double_jump_active = active
	_powerup_ui("DOUBLE JUMP powerup")
	
func _small_powerup(active):
	if active == true:
		print("small powerup active")
		anim.play("small_powerup")
		small_active = active
		small_timer.start()
	_powerup_ui("SMALL MAN powerup")

func _on_small_powerup_timeout() -> void:
	anim.play_backwards("small_powerup")
	small_active = false
	small_timer.stop()
	
func _check_dash():
	if Input.is_action_just_pressed("dash"):
		if(dash_active):
			$player_audios/dash.play()
			var aim = camera.get_global_transform().basis
			var dash_direction = Vector3()
			dash_direction += aim.z * (cam_marker.global_position.z * -(1/ cam_marker.global_position.z))
			dash_direction = dash_direction.normalized()
			var dash_vector = dash_direction * DASH_SPEED
			print(dash_vector)
			velocity += dash_vector
			print("dash used")
			dash_active = false
			
# Custom Tile Behavior
func _player_on_ice():
	if (ice == true):
		still_ice = true
		return
	ice = true
	ice_vec = Vector3(velocity.x, 0, velocity.z)
	print(ice_vec)

func _player_off_ice():
	if (still_ice == true):
		still_ice = false
	else:
		ice = false

	
func _launch_player():
	velocity = Vector3(velocity.x,LAUNCH_PLAYER_VEL,velocity.z)
	
func _on_wall_jump_entered(body: Node3D) -> void:
	if (body.is_in_group("wall_jump")):
		print("this is a wall")
		wall_jump_active = true
		pass
		
func _on_wall_jump_exited(body: Node3D) -> void:
	if (body.is_in_group("wall_jump")):
		print("left the wall")
		wall_jump_active = false
		pass

			
func _win():
	$powerup_pickup.hide()
	$win_screen.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true

func _play_footstep_audio():
	footstep_audio.pitch_scale = randf_range(0.6, 0.8)
	footstep_audio.play()

func _pause_menu():
	if get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = false
		pause_menu.hide()
		
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		pause_menu.show()
	

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		_pause_menu()
		print("pause pressed")
		$powerup_pickup.hide()

func _powerup_ui(label):
	$powerup_pickup/Label.text = label
	$powerup_pickup.show()
	var pickup_timer:Timer = Timer.new()
	pickup_timer.wait_time = 3
	add_child(pickup_timer)
	pickup_timer.one_shot = false
	pickup_timer.autostart = false
	pickup_timer.timeout.connect(func(): $powerup_pickup.hide())
	pickup_timer.start()
	
func _restart():
	$powerup_pickup.hide()
	$restart_screen.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
