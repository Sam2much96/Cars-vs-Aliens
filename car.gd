extends VehicleBody


class_name CarClass

onready var gameManager = get_tree().get_root().get_node("root/GameManager")# pointer to Game Manager Class


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


enum {MOVE_FORWARD, REVERSE, STEER_LEFT, STEER_RIGHT}

# Input Events
func _input(event):
	
	# Testing Acceleration
	#set_engine_force(1000)
	
	# Mobile Inputs
	if event is InputEventScreenTouch: # TO DO: Map Touch input to Car Movements
		print_debug(event.get_position())
	
	pass


func _ready():
	
	pass


func _process(delta):
	# Game Over Trigger
	if (speed < 10):
		gameManager.gameOver()
	
	if (FallingBelowMap):
		gameManager.gameOver()
	pass



func _physics_process(delta):
	
	# Left and Right Steering
	# Converts Left and Right Input map to an integer which is ued to control car movements
	steering = lerp(steering, Input.get_axis("right","left") * 0.4, 5 * delta)
	
	
	# Forword and Backwards Acceleration
	var acceleration = Input.get_axis("down","up") # multiply by random force value link a 100
	var rpm = $backwheel1.get_rpm()
	
	# calculation to add some mechanical drag
	$backwheel1.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
	
	rpm = $backwheel2.get_rpm()
	
	
	# calculation to add some mechanical drag
	$backwheel2.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
	
	
	#//moves the car forward
	#transform.Translate(Vector3.forward * Time.deltaTime * speed * forwardInput);   
	 
	#//moves the car sideways
	#transform.Rotate(Vector3.up, turnSpeed * horizontalInput * Time.deltaTime );
	
	pass


func _on_collision(area):
	if area.name == "Rock":
		speed /= 2
		
		impact()
	if area.name == "Gems":
		UpdateScore(50)
		print_debug("Gem")
		
		# Destroy Gem Object
	

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
