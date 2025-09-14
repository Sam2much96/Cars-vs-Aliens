# *************************************************
# godot3-Cars-vs-Aliens-game by INhumanity_arts
# Released under MIT License
# *************************************************
# Game Manager
# Game Manager Singleton
#
# Features:
# (1) Manages the game state
# (2) Triggers various game states
# (3) SHows / Hides game hud which is it's child
#
# TO Do:
# (1) separate the game manager and game hud objects into separate singletons
# *************************************************


extends Node


class_name GM

export (bool) var isGameActive
export (bool) var isGamePaused
export (bool) var show_wallet


# Buttons
#var menu_button : Button
#var wallet_button : Button

# Scene Objects
var titleScreen : PackedScene

## Texts
#var walletText : Label
#var menu_text : Label

onready var car_object : VehicleBody

func _ready():
	# Start game
	isGamePaused = false
	
	


func StartGame() -> void:
	isGameActive = true
	


# Tracks if game is paused and shows / hides title screen & menu nodes
func _process(delta):
	# Game Over Trigger
	if (car_object.speed < 10):
		#gameManager.gameOver()
		GameOver()
	
	if (car_object.FallingBelowMap):
		#gameManager.gameOver()
		GameOver()


func ShowWallet():
	# TO DO:
	# (1) Connect to api wallet
	pass

func RestartGame():
	pass


func PauseGame():
	pass

func ResumeGame():
	pass

func GameOver():
	# TO DO
	# (1) Show titlescreen
	# (2) Stop game
	print_debug(" Game Over")

