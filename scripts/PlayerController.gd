# *************************************************
# godot3-Dystopia-game by INhumanity_arts
# Released under MIT License
# *************************************************
# 3DPlayerControler v2
#Simple Freelook Camera Code as 3d player controller + player controller
#
# Source : https://github.com/adamviola/simple-free-look-camera 
#
# Features:
#
# *************************************************
# To Do:
# (1) Refactor to use player controls
# (2) Refactor to use Camera Shake fx to simulate player movement


extends KinematicBody
# functions:
# (1) controls the 3d player animation
# (2) controlls the 3d player movement

# to do:
# (1) implement interract and scene transition  with car object
# (2) implement player walk around (1/2)
# (3) port fps shooter state from godot 4 kenny starter kit

# animation player nodes
onready var anim : AnimationPlayer = $AnimationTree/AnimationPlayer

# player states
enum {WALKING,RUNNING, ATTACK, ENTER_VEHICLE, EXIT_VEHICLE, DRIVING, SWIMMING}

var state = WALKING
var velocity := Vector3.ZERO

# Movement parameters
# to do :
# (1) export walking parameters outside to the inspector tab 
var walk_speed := 5
var run_speed := 9
var gravity := -24
var jump_force := 10  # optional

func _ready():
	pass


func _physics_process(delta):
	# implement 3d movement physics
	match state:
		WALKING:
			#state_walking(delta)
			anim.play("Walk_Loop");
			
			# implment walking and look around physics
			
			
		RUNNING:
			#state_running(delta)
			pass
		ATTACK:
			#state_attack(delta)
			pass
		ENTER_VEHICLE:
			#state_enter_vehicle(delta)
			pass
		EXIT_VEHICLE:
			#state_exit_vehicle(delta)
			pass
		DRIVING:
			#state_driving(delta)
			pass
		SWIMMING:
			#state_swimming(delta)
			pass
