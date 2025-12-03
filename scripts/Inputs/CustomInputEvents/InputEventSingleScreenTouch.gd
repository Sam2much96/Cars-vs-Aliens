# *************************************************
# godot3-Dystopia-game by INhumanity_arts
# Released under MIT License
# *************************************************
# Custom Input Class To Serialise Single Screen Touch To Global Input Class
#
#
#
# *************************************************


class_name InputEventSingleScreenTouch
extends InputEventAction

var position : Vector2

func _init(e):
	position = e.position
	pressed = e.pressed


func as_text():
	return "InputEventSingleScreenTouch : position=" + str(position) + ", pressed=" + str(pressed)
