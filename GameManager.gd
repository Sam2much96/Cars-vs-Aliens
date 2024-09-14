extends Node


class_name GM

export (bool) var isGameActive
export (bool) var isGamePaused
export (bool) var show_wallet


# Buttons
var menu_button : Button
var wallet_button : Button

# Scene Objects
var titleScreen : PackedScene

# Texts
var walletText : Label
var menu_text : Label

func _ready():
	# Start game
	isGamePaused = false
	
	


func StartGame() -> void:
	pass

func _process(delta):
	pass


func ShowWallet():
	pass

func RestartGame():
	pass


func PauseGame():
	pass

func ResumeGame():
	pass

func GameOver():
	pass

