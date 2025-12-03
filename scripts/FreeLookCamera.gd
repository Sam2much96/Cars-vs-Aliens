# *************************************************
# godot3-Dystopia-game by INhumanity_arts
# Released under MIT License
# *************************************************
# 3DPlayerControler 
#Simple Freelook Camera Code as 3d player controller
#
# Source : https://github.com/adamviola/simple-free-look-camera 
#
# Features:
# 
# *************************************************
# To Do:
# (1) Refactor to use player controls
# (2) Refactor to use Camera Shake fx to simulate player movement
# (3) document code bace

extends Camera

class_name FreeLookCamera 

# Modifier keys' speed multiplier
const SHIFT_MULTIPLIER = 2.5
const ALT_MULTIPLIER = 1.0 / SHIFT_MULTIPLIER

export(float, 0.0, 1.0) var sensitivity = 0.25

# Mouse state
var _mouse_position = Vector2(0.0, 0.0)
var _total_pitch = 0.0

# Movement state
var _direction = Vector3(0.0, 0.0, 0.0)
var _velocity = Vector3(0.0, 0.0, 0.0)
var _acceleration = 30
var _deceleration = -10
var _vel_multiplier = 4

# Keyboard state
# Movement body states
# used in camera movement calculations
var _w : bool = false
var _s : bool = false
var _a : bool = false
var _d : bool = false
var _q : bool = false
var _e : bool = false
var _shift : bool = false
var _alt : bool = false
#
func _input(event):
	# Refactor input to use Dpad instead
	#push_error(" Refactor 3D camera input for D-pad and Mobile Devices")
	# Receives mouse motion
	# mouse motion
	if event is InputEventMouseMotion:
		_mouse_position = event.relative
		
		#print_debug(_mouse_position)# for debug purposes only
	
	# Mobile Screen Capture
	# Screen Drag
	# Doesnt work

	
	# Receives mouse button input
	# mouse state machine
	# mouse button
	if event is InputEventMouseButton:
		match event.button_index:
			BUTTON_LEFT: # Only allows rotation if right click down
				
				# captures move input and Makes Mouse Invisible COnditionals
				if event.pressed :
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				else: 
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

			BUTTON_WHEEL_UP: # Increases max velocity
				_vel_multiplier = clamp(_vel_multiplier * 1.1, 0.2, 20)
			BUTTON_WHEEL_DOWN: # Decereases max velocity
				_vel_multiplier = clamp(_vel_multiplier / 1.1, 0.2, 20)

	# Receives key input
	# keyboard state machine
	# refactor to us GLobal Input Singleton code
#
# Buggy
# 3D Camenra movement implementation
	if Input.is_action_pressed("move_down"):
		_s = true
		return
	if Input.is_action_just_released("move_up"):
		_s = false
		return
	
	if Input.is_action_pressed("move_up"):
		_w = true
		return
	if Input.is_action_just_released("move_up"):
		_w = false
		return
	
	if Input.is_action_pressed("move_left"):
		_a = true
		return
	if Input.is_action_just_released("move_left"):
		_a = false
		return
	
	
	if Input.is_action_pressed("move_right"):
		_d = true
		return
	if Input.is_action_just_released("move_right"):
		_d = false
		return

#			KEY_SHIFT: # increase mmovement speed
#				_shift = event.pressed
#			KEY_ALT: # increase movement speed
#				_alt = event.pressed
#
# Updates mouselook and movement every frame
func _process(delta):
	
	#Update Camera look
	_update_mouselook()
	
	# Update Camera movment
	_update_movement(delta)

# Updates camera movement
func _update_movement(delta):
	# Computes desired direction from key states
	# uses an algorithm to convert input events to Vector3 co-ordinates
	_direction = Vector3(_d as float - _a as float, # Left or Rigth
						 _e as float - _q as float,
						 _s as float - _w as float)
	
	
	# Debug Direciton
	#print_debug(_direction)
	
	# Computes the change in velocity due to desired direction and "drag"
	# The "drag" is a constant acceleration on the camera to bring it's velocity to 0
	var offset = _direction.normalized() * _acceleration * _vel_multiplier * delta \
		+ _velocity.normalized() * _deceleration * _vel_multiplier * delta
	
	# Compute modifiers' speed multiplier
	# speed multiplier using the alt and shift keys 
	var speed_multi = 1
	if _shift: speed_multi *= SHIFT_MULTIPLIER
	if _alt: speed_multi *= ALT_MULTIPLIER
	
	# Checks if we should bother translating the camera
	if _direction == Vector3.ZERO and offset.length_squared() > _velocity.length_squared():
		# Sets the velocity to 0 to prevent jittering due to imperfect deceleration
		_velocity = Vector3.ZERO
	else:
		# Clamps speed to stay within maximum value (_vel_multiplier)
		_velocity.x = clamp(_velocity.x + offset.x, -_vel_multiplier, _vel_multiplier)
		_velocity.y = clamp(_velocity.y + offset.y, -_vel_multiplier, _vel_multiplier)
		_velocity.z = clamp(_velocity.z + offset.z, -_vel_multiplier, _vel_multiplier)
	
		translate(_velocity * delta * speed_multi)

# Updates mouse look 
func _update_mouselook():
	# Only rotates mouse if the mouse is captured
	#
	# Camer Rotation COnditional
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_mouse_position *= sensitivity
		var yaw : float = _mouse_position.x
		var pitch : float = _mouse_position.y
		_mouse_position = Vector2(0, 0)
		
		# Prevents looking up/down too far
		pitch = clamp(pitch, -90 - _total_pitch, 90 - _total_pitch)
		_total_pitch += pitch
	
		rotate_y(deg2rad(-yaw))
		rotate_object_local(Vector3(1,0,0), deg2rad(-pitch))
