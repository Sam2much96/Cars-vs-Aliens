extends Node

# Destroys this node after a timeout
var time_left = 5.0

func _process(delta):
	time_left -= delta
	if time_left < 0:
		queue_free()
