# *************************************************
# godot3-Cars-vs-Aliens-game by INhumanity_arts
# Released under MIT License
# *************************************************
# Music Singleton
# 
#
# Features:
# (1) Manages the game music and sfx
# (2) Implements different ingame sfx during playtime
# (3) Plays in-game Radio Recordings
# (4) Is mapped to the Player's stats/ radio UI
# *************************************************
# TO Do:
# (1) Implement all Core Music functions
# (2) Implement Player's stats UI and Radio Channel UI
#
# *************************************************

extends Node

class_name Music

export (bool) var Enabled : bool

# to do: (1)

export (Dictionary) var music = {0: ""}
export (Dictionary) var carSfx = {0: ""}
export (Dictionary) var citySfx = {0: ""}

onready var stream : String = "" 

# music and sfx players
onready var A = get_node("A")
onready var B = get_node("B")
onready var C = get_node("C")
onready var D = get_node("D")

# Called when the node enters the scene tree for the first time.
func _ready():
	if Enabled:
		A.play()


