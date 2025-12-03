# *************************************************
# godot3-Dystopia-game by INhumanity_arts
# Released under MIT License
# *************************************************
# Custom input Class to serialise Screen Drag to Global Input Class
#
#
#
# *************************************************


class_name InputEventSingleScreenDrag
extends InputEventAction

var position : Vector2 setget set_position, get_position
var relative
var speed

func _init(e):
	position = e.position
	relative = e.relative
	speed = e.speed


func as_text():
	return "InputEventSingleScreenDrag : position=" + str(position) + ", relative=" + str(relative) + ", speed=" + str(speed)

func get_position():
	return position

func set_position(e):
	position = e.position
	pass
