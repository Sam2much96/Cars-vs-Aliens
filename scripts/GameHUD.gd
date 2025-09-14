# *************************************************
# godot3-Cars-vs-Aliens-game by INhumanity_arts
# Released under MIT License
# *************************************************
# Features:
# (1) ame Menu
# (2) Speedometer
# (3) Players stats using GTA Miami vice style font
# (4) Input handler
# *************************************************
# To Do:
# (1) Titlescreen UI
# (2) Better Touch input Event Controller 
# 
# 
# *************************************************

 #"Depreciated touch screen controller Aug 25,2025"

extends Control




# Mobile Input Handler
#One finger touch → accelerate (up).
#Phone tilt → steer left/right (left/right).
#(Optionally) Swipe down → brake (down).



var mobile_accelerating := false
var mobile_braking := false

var gyro_steer_strength := 0.0 # will be used to fake left/right

func _input(event):
	# Handle screen touch for up/down
	if event is InputEventScreenTouch:
		if event.is_pressed():
			#print_debug("screen touch detected ")
			mobile_accelerating = true
		else:
			mobile_accelerating = false

	# You could add a second button or gesture for braking if needed
	# Example: If you use two fingers for brake:
	if event is InputEventScreenDrag:
		if event.get_relative().y > 50:
			mobile_braking = true
		else:
			mobile_braking = false

func _process(delta):
	# Update gyroscope steering every frame
	var tilt = Input.get_accelerometer() # Vector3
	gyro_steer_strength = clamp(tilt.x * 2.5, -1.0, 1.0) # More sensitive tilt

	# Optional: print for debugging
	# print("Gyro tilt X: ", tilt.x, " mapped to steer: ", gyro_steer_strength)

func _physics_process(delta):
	# Fake inputs based on mobile controls

	# Simulate UP input
	if mobile_accelerating:
		Input.action_press("up")
	else:
		Input.action_release("up")
	
	# Simulate DOWN input
	if mobile_braking:
		Input.action_press("down")
	else:
		Input.action_release("down")
	
	# Simulate LEFT/RIGHT based on gyroscope
	if gyro_steer_strength < -0.1:
		Input.action_press("left")
		Input.action_release("right")
	elif gyro_steer_strength > 0.1:
		Input.action_press("right")
		Input.action_release("left")
	else:
		Input.action_release("left")
		Input.action_release("right")
