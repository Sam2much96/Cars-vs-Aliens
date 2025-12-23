# *************************************************
# godot3-Cars-vs-Aliens-game by INhumanity_arts
# Released under MIT License
# *************************************************
# Cars
# 
#
# Features:
# (1) Manages the game input
# (2) Is the player
#
# *************************************************
# TO Do:
# (1) Export all core functions signals and external functions for UI linking
# (2) Implement player rpg 3d character that can enter and exit the car object
# (3) Add advanced screen class
# (4) improve pc controls
# (5) implement player object that can enter and exit the car (1/2)
# (6) implement car moving sfx from music singleton
# (7) implement impact animation and physics
# (8) export acceleration and physics data to the music singleton
# (9) add texture images to model mesh like in the blender model
	# to do:
	# (1) connect vehicle  body activation with player 3d character
	# (2) separate car into 3 states, driving, parked and ai state with 3d navigation mesh for them
	# (3) create area 3d interraction for the player character nodes
	# (4) set a pointer to trigger once the player is detected in the area of the vehicle body 3d
# *************************************************


extends VehicleBody


class_name CarClass

#onready var gameManager = get_tree().get_root().get_node("root/GameManager")# pointer to Game Manager Class


var carParticle # Car particles

# Car Variable
export (float) var speed : float = 80.0
export (float) var turnSpeed : float =50.0
export (float) var timeLeft :float =30.0
export (bool) var isDriving : bool
export (bool) var FallingBelowMap : bool = false

# Maximum Vehicle Values
export (int) var max_rpm : int = 500
export (int) var max_torque : int = 200  


#enum {MOVE_FORWARD, REVERSE, STEER_LEFT, STEER_RIGHT}

# state machine for the vehicle body object
enum {DRIVING, IDLE, LEVITATE}

var state = DRIVING

# get shallow pointers to all core classes .eg. music 
#onready var safe_Music = get_node("/root/WorldEnvironment/Music")


# car object pointers 
onready var backwheel1 : VehicleWheel =$backwheel1
onready var backwheel2 : VehicleWheel = $backwheel2

# car audio 3d
onready var carAudio : AudioStreamPlayer3D = $AudioStreamPlayer3D # buggy

# car camera
onready var carCamera : Camera = $Camera

# car navigation
var acceleration : int


func _ready():
	
	# testing car levitate
	
	pass


func _input(event):
	if event.is_action_pressed("jump") && state == DRIVING:
		state = LEVITATE
		return
	if event.is_action_pressed("jump") && state == LEVITATE:
		state = DRIVING
		return

func _physics_process(delta):
	# car simple state machine
	
	match state:
		DRIVING:
			# reset gravity
			if gravity_scale == 0: gravity_scale = 1
			
			
			# make the car camera the current render
			carCamera.current = true
			# Left and Right Steering
			# Converts Left and Right Input map to an integer which is ued to control car movements
			steering = lerp(steering, Input.get_axis("right","left") * 0.4, 5 * delta)
			
			#print_debug("steering debug: ",steering)
			
			# Forword and Backwards Acceleration
			acceleration = Input.get_axis("down","up") # multiply by random force value link a 100
			
			
			
			var rpm = backwheel1.get_rpm()
			
			# calculation to add some mechanical drag
			backwheel1.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
			
			rpm = backwheel2.get_rpm()
			
			
			# calculation to add some mechanical drag
			backwheel2.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
		IDLE:
			carCamera.current = false
			
		LEVITATE:
			
			# to do:
			# (1) implement car turns while levitating
			# (2) implement gyroscope controls while levitating
			# (3) map car levitate controls to touch screen button
			gravity_scale = 0
			  # Left/right input
			var horizontal_input = Input.get_axis("left", "right")  # -1 = left, 1 = right
			var vertical_input = Input.get_axis("up", "down")       # optional forward/back

			# Lift slightly to prevent falling
			var hover_force = Vector3.UP * 20.0
			add_central_force(hover_force)

			# Move left/right
			#var lateral_force = transform.basis.x * horizontal_input * 50.0  # tweak strength
			#add_central_force(lateral_force)

			# Optional: forward/backward
			var forward_force = transform.basis.z * -vertical_input * 50.0
			add_central_force(forward_force)




# Triggers and Impact animation and Particle fx
func impact():
	print_debug("Impact")

# Reduce Car Speed Upon Collision with Rock Object
func ReduceCarSpeed():
	pass


# Checks If THe Car Kinematic is below the Level's Collision Levels
func isFallingBelowMap() -> bool:
	return false

# Update The Score When Colliding with Gem Object
func UpdateScore(scoreToAdd : int) -> void:
	print_debug(""% [scoreToAdd] )


# testing player interract with vehicle body
func _on_VehicleBody_body_entered(body):
	print_debug("vehicle body debug: ", body, "/", body.name)
