# *************************************************
# godot3-Dystopia-game by INhumanity_arts
# Released under MIT License
# *************************************************
# Custom Input Class to Serialise Single Screen Tap to GLobal Input Class
#
#
#
# *************************************************


class_name InputEventSingleScreenTap
extends InputEventAction

var position

func _init(e):
	position = e.position


func as_text():
	return "InputEventSingleScreenTap : position=" + str(position)
