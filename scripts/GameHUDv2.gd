# *************************************************
# godot3-Cars-vs-Angels-game by INhumanity_arts
# Released under MIT License
# *************************************************
# Features:
# (1) Game HUD
# (2) Speedometer
# (3) Players stats using GTA  style font
# (4) Input handler
# *************************************************
# 
# 
# 
# *************************************************

extends CanvasLayer

# Clock UI handler
onready var clockTimer : Timer = get_node("ClockTimer")
onready var clockLabel : Label = get_node("TopLeft/time")
onready var titleUI : Popup = get_node("DialogPopup")

func _ready():
	
	titleUI.popup()

	# connect clock timer node signals
	if not clockTimer.is_connected("timeout",self,"update_clock"):
		clockTimer.connect("timeout",self,"update_clock")


func update_clock() -> void:
	# works
	#print_debug("updating the current clock time")
	# get curent local time
	var time = OS.get_datetime()
	var hour = str(time.hour).pad_zeros(2)
	var minute = str(time.minute).pad_zeros(2)
	#var second = str(time.second).pad_zeros(2)
	var text = "%s:%s" % [hour, minute]
	clockLabel.set_text(text)
	
	# update the timer to only poll time updates every minute
	clockTimer.wait_time = 60
