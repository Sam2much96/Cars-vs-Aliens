# *************************************************
# godot3-Dystopia-game by INhumanity_arts
# Released under MIT License
# *************************************************
# Game Monetize Script
#
# Features
# (1) triggers game monetize sdk on project ready
# *************************************************


extends Node


func _ready():
	
	# trigger the game monetize sdk ads 
	if Engine.has_singleton("JavaScript"):
		JavaScript.eval("ShowBanner();") # works


