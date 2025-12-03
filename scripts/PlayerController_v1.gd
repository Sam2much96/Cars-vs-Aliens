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
# (1) Free look camera mode
# (2) 
# *************************************************
# 
# To Do :
# (1) document and organise code for 3d player
# (2) backport code back into dystopia rpg source code
# *************************************************
#
# Bugs:
#(1) movement uses global positin instead of local positin for movement logic


extends KinematicBody




var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")#Vector3.DOWN * 20  # strength of gravity
export (float) var speed = 10.0  # movement speed
export (float) var jump_velocity = 15.0  # jump strength
export (float) var acceleration = 10.0
export (float) var friction = 5.0
export (float) var air_friction = 0.5
export (float) var air_acceleration = 1.0
var sensitivity = 0.2
var min_angle = -80
var max_angle = 90


var look_rot = Vector3.ZERO
var move_dir = Vector3.ZERO
var velocity = Vector3.ZERO
var jump = false
onready var head = self
onready var anim = $AnimationTree/AnimationPlayer

# player states
enum {IDLE,WALKING,RUNNING, ATTACK, ENTER_VEHICLE, EXIT_VEHICLE, DRIVING, SWIMMING}

var state = IDLE

func _ready():
	#print_debug("3d player debug: ", rigged_player)
	pass


func _input(event):
	# to do:
	# (1) depreciate the view rotation code to instead use freelook configuraton
	#view rotation
	if event is InputEventMouseMotion:
		look_rot.y -= (event.relative.x * sensitivity)
		look_rot.x -= (event.relative.y * sensitivity)
		look_rot.x = clamp(look_rot.x, min_angle, max_angle)
		

	#if Input.is_action_pressed("move_up"):
		
	#	velocity.z -= speed
	#if Input.is_action_pressed("move_down"):
	#	velocity.z += speed
	#if Input.is_action_pressed("move_right"):
	#	velocity.x += speed
	#if Input.is_action_pressed("move_left"):
	#	velocity.x -= speed
	if Input.is_action_just_pressed("roll"):
		jump = true
	if Input.is_action_just_released("roll"):
		jump = false
	pass

func _physics_process(delta):
	
	# implement 3d movement physics
	match state:
		IDLE:
			if (Input.is_action_just_pressed("up") or 
				Input.is_action_just_pressed("down") or
				Input.is_action_just_pressed("left") or
				Input.is_action_just_pressed("right")
			): 
				state = WALKING
			
		WALKING:
			#state_walking(delta)
			anim.play("Walk_Loop");
			
			# implment walking and look around physics
			head.rotation_degrees.x = look_rot.x
			rotation_degrees.y = look_rot.y
			
			if not is_on_floor():
				velocity.y -= gravity * delta
			if jump and is_on_floor():
				velocity.y = jump_velocity
			
			#if (Input.is_action_pressed("up") or 
			#	Input.is_action_pressed("down") or
			#	Input.is_action_pressed("left") or
			#	Input.is_action_pressed("right")
			#): 
				
			# keyboard move direction
			# to do :
			#
			# (1) fix the move direction to adjust to the scene's rotation
			move_dir = Vector3(Input.get_axis("right","left"), 0, -Input.get_axis("up","down")).normalized().rotated(Vector3.UP, rotation.y)
			
			if (InputEventMultiScreenDrag or
				InputEventSingleScreenDrag or
				InputEventScreenPinch or
				InputEventScreenTwist or
				InputEventSingleScreenTap or
				InputEventSingleScreenTouch
			):
				# Touchscreen Move Direction
				# bug:
				# (1) breaks keyboard inputs
				#move_dir = Vector3(safe_TouchScreen.direction.y, 0, safe_TouchScreen.direction.x)
				pass
			
			velocity.x = lerp(velocity.x, move_dir.x * speed, acceleration * delta)
			velocity.z = lerp(velocity.z, move_dir.z * speed, acceleration * delta)
			
			velocity = move_and_slide(velocity, Vector3.UP)
			
			
		RUNNING:
			#state_running(delta)
			pass
		ATTACK:
			#state_attack(delta)
			pass
		ENTER_VEHICLE:
			#state_enter_vehicle(delta)
			# logic:
			# (0) get a pointer to the car object
			# (1) play the interract animation on the player
			# (2) hide the player model
			# (3) hand over movement to the car / vehicle object
			# (4) overlap the player model into the car object
			anim.play("Driving_Loop")
			
			
			
			
			#pass
		EXIT_VEHICLE:
			#state_exit_vehicle(delta)
			pass
		DRIVING:
			#state_driving(delta)
			pass
		SWIMMING:
			#state_swimming(delta)
			pass

	
	
	
	
	anim.play("Walk_Loop");

