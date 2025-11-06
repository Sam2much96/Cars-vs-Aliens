# *************************************************
# godot3-Dystopia-game by INhumanity_arts
# Released under MIT License
# *************************************************
#
# This is a auto-included singleton containing
# information used by the Game 
# Features
# (1) Functions Class for Saving & Loading.
# (2) A Call to find the current scene
# (3) 
# (4) A video streaming function, which should originally have been a child of the video streamers, 
#     but it runs faster on a singleton script and so, was called from here
# (5) Store video files functions
# (6) It loads scenes for faster switiching between
# To Add
# (1) A working zip and unzip function through GDUnzip repurposed as an editor plugin #('insert GDUNzip github address')
# (2) ArrAnge code base, make it easier to read at a glance (1/2)
# (3) Use resource oader for video loading script

# Bugs
# (1) COnnect to GDUNZIP via editor script to zip and unzip 
# (2) Lacks proper documentation (fixed)
# (3) Lacks Performance Optimization and Proper variable mnaming conventions (fixed)
# (4) Causes a performance hog with process functions
# (5) Causes a ram hog with loaded and preloaded variables (1/2)
# *************************************************

extends Node

class_name GlobalsVar


onready var curr_scene : String = ""
onready var os: String = OS.get_name()
onready var kill_count : int = 0 #update to load from savefile
onready var death_count : int = 0 # also update and save to savefile

# 
var players : Array = [] # All Players
var player #: Player # My Player

# Player cam
#var player_cam 

#var _p # Player placeholder
var hp : int
var enemy = null
var enemy_debug : String 
const initial_level : String = "res://scenes/levels/Overworld.tscn"  # loading outside environment bug fixed

var video_stream #for the video streamers



# warning-ignore:unused_class_variable
var spawnpoint : Vector2 
var spawn_x : float = 0.0
var spawn_y : float = 0.0
var current_level : String = ""


# Music



var _controller_type : Dictionary = {1:'modern', 2:'classic'}
var direction_control  : String = _controller_type[2]  #toggles btw analogue and d-pad

var uncompressed # Varible holds uncompressed zip files



var cinematics : PackedScene 





"Crypto Variables" 
var address : String 
var mnemonic : String 
var player_name : String 

# Rewrite load acccount info into save file function
var algos : int  #=  Wallet.Wallet.load_account_info(false, Wallet.token_write_path, Wallet.FileCheck3, Wallet.UserData).get("_wallet_algos")

#MicroAlgos 
var suds : int 

"Device Variables"
onready var user_data_dir : String =OS.get_user_data_dir()

"safe Pointers to Global Singletons"
onready var safe_GameHud = get_node("/root/GameHud/TouchInterface")
onready var utils_singleton = get_node("/root/Utils")

"Screen Orientation"
# for upscaling and downscaling UI
# temporarily disabling Nov 6, 2025 update
onready var screenOrientation : int #= safe_GameHud.Screen.Orientation() 
var viewport_size : Vector2
var center_of_viewport : Vector2 



"Node Pointer"
#var _smoke_fx_ 

'Temporary variants'
#var temp






"Game Map"
# Features
# (1) Speeds up loading times by hiding it behind cinematics
# Depreciated
#var tile_map : TileMap
var OverWorld #: PackedScene

var player_cam : Camera setget set_PlayerCam, get_PlayerCam

#onready var nodes = [blood_fx,despawn_fx,self]
func _ready():
	#print_debug('Blood fx:',blood_fx) #optimize blood fx to only load during game runtimes
	#print_debug("Despawn Fx:", despawn_fx)
	
	algos = 0
	suds = 0
	player_name = ""
	address = ""
	
	#Set White Background
	VisualServer.set_default_clear_color(ColorN("white")) 
	
	

func update_curr_scene() -> void:
	curr_scene= get_tree().get_current_scene().get_name() 


func _go_to_cinematics():
	
	return 0


"Player Cam Setters and Getters"
func set_PlayerCam(camera_ref : Camera):
	player_cam = camera_ref

func get_PlayerCam() -> Camera:
	return player_cam
