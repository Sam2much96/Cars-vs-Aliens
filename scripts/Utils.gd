# *************************************************
# godot3-Dystopia-game by INhumanity_arts
# Released under MIT License
# *************************************************
# Utils Version 2
# Contains Shared Calculation Codes between scenes
# Features:
# (1) Handles all Gameplay Calculations
# (2) Implements Multithreading and Share Core Utility Functionality
# (3) Codebase is structured in reference classes that auto garbage collect
#
# *************************************************

extends Node


export(int) var screenOrientation : int 
export (Vector2) var viewport_size : Vector2
export (Vector2) var center_of_viewport : Vector2 

export (Array) var EnemyObjPool : Array = [] #Stores shared pointer to enemy Mob instances

onready var dir : Directory = Directory.new() # Global FIle And Directory Paths
onready var file : File = File.new()


class Player_utils extends Reference :
	
	
	
	func _get_player(scene_tree : SceneTree) :
	#
	# Gets the Player Object in the Scene Tree if Player unavailable 
	#	
	# Rewrite into a separate function
	
	# get the globals singleton within this context
		var Globals = scene_tree.get_node("/root/Globals")
		Globals.players.append( scene_tree.get_nodes_in_group('player') )#gets all player nodes in the scene
		 #it shows deleted object once player is despawns.
		if Globals.players.empty() == true: #error catcher 1            
			Globals.players.clear()
		#
		if Globals.player == null:
			Globals.player = Globals.players[0] # Incase there are more than 1 players
		return Globals.player


# Calculates the center of a Rectangle
static func calc_center_of_rectangle(rect : Vector2) -> Vector2:
	return Vector2((rect.x/2), (rect.y/2))

# Produces Truely Randomized Results
func randomize_enemy_type() -> String:
	randomize()
	#_randomize(self)
	return ['Easy', "Intermediate", "Hard"][randi()%3]

# Randomizes node
# FIxes the randomize states on Game Objects
#func _randomize(node):
	#node.get_script().
#	return randomize()

static func array_to_string(arr: Array) -> String:
	# Used For Multiplayer data Encoding
	# Converts an array to a string and concatonates it
	# The result s is then converted to an integer
	# This is a simple encoding formulae for input and state buffer to reduce data packet size
	var s = ""
	for i in arr:
		s += String(i)
	return s

static func int_to_array(data : int)-> Array:
	# Used For Multiplayer Data decoding
	# converts a large integer into separate value and encodes the result into an array
	# essentialy decoding the data that array_to_string encodes
	# used in simulation logic
	var num_str = str(data)
	var num_array = []
	for i in range(num_str.length()):
		num_array.append(int(num_str[i]))
	return num_array




	# Convert bytes to Megabytes
static func _ram_convert(bytes) :
	if bytes >= int(1):
		var _mb = String(round(float(bytes) / 1_048_576))
		return _mb

"Memory Leak/ Orphaned Nodes Management System"
class MemoryManagement extends Reference :
	# To-Do: Method Should Implement a THread
	
	static func queue_free_children(node: Node) -> void:
		for idx in node.get_child_count():
			node.queue_free()
			
	static func free_children(node: Node) -> void:
		for idx in node.get_child_count():
			node.free()

	static func free_object (object: Object) -> void:
		object.free()

	static func queue_free_array(nodes: Array) -> void:
		# SHould Ideally Spawn a THread
		
		for i in nodes:
			if is_instance_valid(i):
				if i != null:
					i.queue_free()

	#prints all orphaned nodes in project
	static func memory_leak_management(from : Node):
		return from.print_stray_nodes() 


"Functions Class"

class Functions extends Reference:
	# Shared Functions Class
	

	
	static func hasSave(utilsFile: File) -> bool:
		#var safe_Utils = safeTree.get_root().get_node("/root/Utils")
		# simple logic to check if the player already has a saved file
		var save_game = utilsFile
		
		if save_game.file_exists("user://savegeme.save"):
			return true
		else : return false
	
	static func deleteSave(utilsFile : File, utilsDir : Directory):
		 # Deletes the game's save file and resets all player stats and settings
		if utilsFile.file_exists("user://savegeme.save"):
			print_debug("deleting save file user://savegeme.save")
			
			# delete the file using directory
			utilsDir.remove("user://savegeme.save")
	
	static func change_scene_to(scene : PackedScene, tree : SceneTree): #Loads scenes faster?
		#print_stack()
		if scene != null: 
			var Globals = tree.get_node("/root/Globals")
			tree.change_scene_to(scene)
			Globals.update_curr_scene()
			return   

		else: 
			push_error(str(scene)+" "+ str(typeof(scene)) +"is not supported in this function")
	
	'Resource Loader FOr Large Scenes'
	# Refactored to Loading Scene
	static func LoadLargeScene(
		_to_load : String, 
		scene_resource : PackedScene, 
		_o : ResourceInteractiveLoader, 
		scene_loader : ResourceLoader, 
		_loading_resource : bool, 
		a: float , 
		b : float, 
		progress: float
		) -> PackedScene:
		
		print_debug("Loading Large Scene")
		if _to_load != "" && scene_resource == null:
			var time_max = 50000 #sets an estimate maximum time to load scene
			var t = OS.get_ticks_msec()
			
			
			_o= (scene_loader.load_interactive(_to_load)) #function returns a resourceInteractiveLoader

			scene_loader.load_interactive(_to_load) #function returns a resourceInteractiveLoader
			
		
			print_debug (" Loader Debug Outer loop >>> Inner Loop")
			while OS.get_ticks_msec() < (t + time_max) && _o != null: 

				var err = _o.poll()
				#loading_resource = true
				
				push_warning("_q: "+str(scene_resource)+" _r: "+str(_to_load)+" Error: "+str(err)+"Loop Debug") #Debugger
				
				
				
				if err == ERR_FILE_EOF: # Finished Loading #Works
					_loading_resource = false
					
					scene_resource = (_o.get_resource()) 
					print_debug (scene_resource , "Resource Loaded")
					push_warning (str(scene_resource) + "Resource Loaded")
					
					break
					#return _q
				# Tracks Scene Resource Progress. 
				# Should be exportable to UI/ UX
				elif err == OK: #works
					a = _o.get_stage()
					b = _o.get_stage_count() 
					progress = (b/a) 
					print_debug (a, "/",b,'/',"Progress: ", progress) #progress Debug?
					push_warning (str(a)+ "/"+str(b)+'/'+"Progress: "+ str(progress)) #progress Debug?
				
				
				else: # Error during loading
					push_error("Problems loading Scene.  Debug Gloabls scene loader")
					push_error(str(progress) + "% " + str (_to_load))
					break
					
		if scene_resource != null: # 
			return scene_resource
		
		return scene_resource



	"""
	Really simple save file implementation. Just saving some variables to a dictionary
	"""
	# Can Save individual parameters by setting other parameters to Null
	#
	#
	static func save_game( 
		safeTree : SceneTree
		)-> bool: 
		
		print_debug ("-------Saving Game -------")
		# because this is a static function, i will get getting all the required 
		# global variable data safely to avoid crashing bugs 
		
		
		# this function saves state data from each of the autoload singleton to
		# an on device json file
		var safe_Utils = safeTree.get_root().get_node("/root/Utils") 
		var safe_Inv = safeTree.get_root().get_node("/root/Inventory") 
		var safe_Globals = safeTree.get_root().get_node("/root/Globals") 
		var safe_Diag = safeTree.get_root().get_node("/root/Dialogs")
		var safe_Music = safeTree.get_root().get_node("/root/Music")  
		var safe_Quest = safeTree.get_root().get_node("/root/Quest") 
		var safe_HUD = safeTree.get_root().get_node("/root/GameHud")
		var safe_Screen = safe_HUD.TouchInterface
		
		var save_dict : Dictionary = {}
		var save_game = safe_Utils.file #File.new() #Utils.file 
		save_game.open("user://savegeme.save", File.WRITE_READ)
		#if !player.empty():
		#	save_dict.player = player #saves the player node 
		#if spawn_x != 0:
		#	save_dict.spawn_x = spawn_x
		#if spawn_y != 0:
		#	save_dict.spawn_y =spawn_y
		
		if not safe_Globals.current_level.empty() :
			save_dict.current_level = safe_Globals.current_level
		
		# Inventory List is saved individually
		if !safe_Inv.list().empty():
			save_dict.inventory = safe_Inv.list()
		if !safe_Quest.get_quest_list().empty():
			save_dict.quests = safe_Quest.get_quest_list()
		if not safe_Globals.os.empty():
			save_dict.os = safe_Globals.os
		if safe_Globals.kill_count != 0 :
			save_dict.kill_count = safe_Globals.kill_count
		if safe_Globals.death_count != 0:
			save_dict.death_count = safe_Globals.death_count
		# Save Device's Tokens
		if safe_Globals.suds != 0:
			save_dict.suds = safe_Globals.suds
		
		if safe_Globals.hp != 0: # why not HP acronym?
			save_dict.hp = safe_Globals.hp
		
		#Music on settings is a boolean converted to int
		if safe_Music != null : 
			save_dict.music = int(safe_Music.enable) #add other variables to save
		
		# Language is saved independently
		if not safe_Diag.language.empty():
			save_dict.languague = safe_Diag.language
		
		# Control Settings
		# Vibration
		save_dict.vibrate = int(safe_Screen.vibrate_)
		
		save_game.store_line(to_json(save_dict))
		save_game.close()
		print ("saved gameplay")
		return true

	"""
	LOAD GAME version 1
	
	Features:
		(1) If check_only is true it will only check for a valid save file and return true or false 
		without restoring any data
		(2) Saves and loads data to and from the game's global data
		(3) Saves and loads all data rather than individual data
	"""
	static func load_game(check_only : bool, safeTree : SceneTree) -> bool:
		check_only = false
		print ("-------Loading Game -------")
		# because this is a static function, i will get getting all the required 
		# global variable data safely to avoid crashing bugs 
		
		
		# this function saves state data from each of the autoload singleton to
		# an on device json file
		var safe_Utils = safeTree.get_root().get_node("/root/Utils") 

		var save_game : File = safe_Utils.file #= File.new()
		var save_dict : Dictionary
		
		if not save_game.file_exists("user://savegeme.save"):
			push_error("no saved game file in user://savegame.save")
			return false
		var err = save_game.open("user://savegeme.save", File.READ)
		var length = save_game.get_len() # checks for corrupted
		if err == OK && length > 0:
			# Bug :
			# (1) Code doesn't account for corrupted save files (fixed)
			#print_debug("Save file debug 1 : ", length)
			
			save_dict = parse_json(save_game.get_line())
			if typeof(save_dict) != TYPE_DICTIONARY:
				return false
			
			if not check_only: #update the global singeton with restored data
				_restore_data(save_dict, safeTree)
		
			save_game.close()
			return true
		if length == 0:
			push_error("Save File is Corrupted")
			return false
		else : return false

	"""
	Restores data from the JSON dictionary inside the save files
	"""
	static func _restore_data(save_dict : Dictionary, safeTree: SceneTree):
		
		# because this is a static function, i will get getting all the required 
		# global variable data safely to avoid crashing bugs 
		
		
		# this function saves state data from each of the autoload singleton to
		# an on device json file
		var safe_Utils = safeTree.get_root().get_node("/root/Utils") 
		var safe_Inv = safeTree.get_root().get_node("/root/Inventory") 
		var safe_Globals = safeTree.get_root().get_node("/root/Globals") 
		var safe_Diag = safeTree.get_root().get_node("/root/Dialogs")
		var safe_Music = safeTree.get_root().get_node("/root/Music")  
		var safe_Quest = safeTree.get_root().get_node("/root/Quest") 
		#var safe_HUD = safeTree.get_root().get_node("/root/GameHud")
		#var safe_Screen = safe_HUD.TouchInterface
		
		
		"Quest Loader"
		
		if save_dict.has('quests'):
			# JSON numbers are always parsed as floats. In this case we need to turn them into ints
			for key in save_dict.quests:
				save_dict.quests[key] = int(save_dict.quests[key])
			safe_Quest.quest_list = save_dict.quests
		
		"Inventory Loader"
		
		if save_dict.has('inventory'):
			# JSON numbers are always parsed as floats. In this case we need to turn them into ints
			for key in save_dict.inventory:
				save_dict.inventory[key] = int(save_dict.inventory[key])
			safe_Inv.inventory = save_dict.inventory
		
		'OS loader'
		
		if save_dict.has('os'):
			safe_Globals.os = save_dict.os
		
		if save_dict.has("suds"):
			safe_Globals.suds = save_dict.suds
		
		'Player details'
		
			
		if save_dict.has("kill_count"):
			safe_Globals.kill_count = save_dict.kill_count  
			
		
		if save_dict.has('player_hitpoints'):
			safe_Globals.hp = int(save_dict.hp)
		
		if save_dict.has('death_count'):
			safe_Globals.death_count = int(save_dict.death_count)
		
		
		
		'Player Object Spawn Position'
		
		
		'Saves Player Spawn Point'
		if save_dict.has('current_level'):
			safe_Globals.current_level = save_dict.current_level
		
		 
		"Scene Loader"
		# to do:
		# (1) simplify to an event system as a child of the dialogs system
		
		
		
		if save_dict.has("languague"):
			safe_Diag.language = save_dict.languague

		#if save_dict.has("vibrate"):
		#	GlobalInput.vibrate_ = bool(save_dict.vibrate)

		if save_dict.has("music"):
			#print_debug("Mus: ",bool(save_dict.music)) # For Debug Purposes Only
			safe_Music.enable = bool(save_dict.music)

		print_debug("Loaded gameplay")

	"""
	Version 2 save game and load game Functions
	
	features:
	(1) less verbose
	(2) Better error handling
	(3) Saves and loads only one variant rather than the entire global states
	"""

	# Loads Singular User Data from local storage
	# Version 2 of Load_game function
	# Should allow for loading individual variables from Local
	# uses a default params
	static func load_user_data( data: String , safeTree : SceneTree ): 
		
		print_debug("Loading User Data >>>", data)
		var safe_Utils = safeTree.get_root().get_node("/root/Utils") 
		var safe_Inv = safeTree.get_root().get_node("/root/Inventory") 
		var safe_Globals = safeTree.get_root().get_node("/root/Globals") 
		var safe_Diag = safeTree.get_root().get_node("/root/Dialogs")
		var safe_Music = safeTree.get_root().get_node("/root/Music")  
		var safe_Quest = safeTree.get_root().get_node("/root/Quest") 
		#var safe_HUD = safeTree.get_root().get_node("/root/GameHud")
		#var safe_Screen = safe_HUD.TouchInterface
		
		
		var save_game = safe_Utils.file 
		if (!save_game): save_game = File.new()
		
		if not save_game.file_exists("user://savegeme.save"):
			return false
		save_game.open("user://savegeme.save", File.READ)
		var save_dict = parse_json(save_game.get_line())
		if typeof(save_dict) != TYPE_DICTIONARY:
			return false
		
		if !save_dict.has(data): # guard clause
			push_error("data loaded not present in save file: " + data)

		#if save_dict.has(data):
		#	print_debug ("Loading user data: ", data)
		if data == "language":
			safe_Diag.language = save_dict.languague
		if data == "music":
			safe_Music.enable = bool(save_dict.music)
		if data == "kill_count" &&save_dict.has("kill_count"):
			safe_Globals.kill_count = save_dict.kill_count  
		if data == "death_count" && save_dict.has("death_count"):
			safe_Globals.death_count = int(save_dict.death_count)
		if data == "suds"&& save_dict.has("suds"):
			safe_Globals.suds = save_dict.suds
		if data == "quests" && save_dict.has("quests"):
			# JSON numbers are always parsed as floats. In this case we need to turn them into ints
			for key in save_dict.quests:
				save_dict.quests[key] = int(save_dict.quests[key])
			safe_Quest.quest_list = save_dict.quests
		if data == "inventory" && save_dict.has("inventory"):
			for key in save_dict.inventory:
				save_dict.inventory[key] = int(save_dict.inventory[key])
			safe_Inv.inventory = save_dict.inventory
		if data == "current_level":
			safe_Globals.current_level = save_dict.current_level
	
	
	



	static func calculate_length_breadth(point_positions: Array) -> Vector2:
		# Calculates the Length and Breadth of a 2Dimensional Vector
		
		var min_x = float('inf')
		var max_x = -float('inf')
		var min_y = float('inf')
		var max_y = -float('inf')

		# Find the minimum and maximum x and y coordinates
		for point in point_positions:
			min_x = min(min_x, point.x)
			max_x = max(max_x, point.x)
			min_y = min(min_y, point.y)
			max_y = max(max_y, point.y)

		# Calculate the length and breadth
		var length = max_x - min_x
		var breadth = max_y - min_y

		return Vector2(length, breadth)
 
	static func edge_length(point_data: PoolVector2Array) -> Vector2:
	# Caclulates the Edge Length of a 4 Point Structure
	# Calculates the distance between 2 points
	# Source : https://stackoverflow.com/questions/7475004/calculate-width-and-height-from-4-points-of-a-polygon
		var width = sqrt(pow(point_data[1].x - point_data[0].x, 2) + pow( point_data[1].y - point_data[0].y,2)) 
		var height = sqrt(pow(point_data[2].x - point_data[1].x, 2) + pow( point_data[2].y - point_data[1].y,2)) 
		return Vector2(width, height)



"Procedural Generation"
class procedural extends Reference:
	# Bug: Maxes Out Static Memory, Refactored to use dynamic memeory instead
	#
	
	static func genereate(simplex_noise : OpenSimplexNoise, 
	world_seed : String, 
	noise_octaves : int, 
	noise_period : int, 
	noise_persistence : float, 
	noise_lacunarity : float, 
	noise_threshold : float,
	map_height : int,
	map_width : int,
	tile_map : TileMap
	):
		# generate a seed using a string and the hash of that string
		simplex_noise.seed = world_seed.hash()
		
		# set simplex noise using Editor values
		simplex_noise.octaves = noise_octaves
		simplex_noise.period = noise_period
		simplex_noise.persistence = noise_persistence
		simplex_noise.lacunarity = noise_lacunarity
		
		# Loop to every tile within Map Area Co-ordinates
		for x in range( round(-map_width) / 2, round(map_width) / 2):
			for y in range(round(-map_height) / 2, round(map_height) / 2):
				
				# conditional
				if simplex_noise.get_noise_2d(x, y) < noise_threshold:
					
					# generataes a tilemap
					_set_autotile(x, y, tile_map)
		if is_instance_valid(tile_map):
			tile_map.update_dirty_quadrants()


	# Sets the scenes autotile programmatically
	# Uses the Tilemap's set cell method & the x and y auto tile co-ordinates
	static func _set_autotile(x : int, y : int, tile_map : TileMap) -> void :
		if is_instance_valid(tile_map):
			tile_map.set_cell(
				x,
				y, 
				tile_map.get_tileset().get_tiles_ids()[0], # Tile ID, the first one 
				false, # Completeley ignore the next three arguments
				false, 
				false, 
				tile_map.get_cell_autotile_coord(x, y ) # co-ordinate of the TileSet
			)
			
			tile_map.update_bitmask_area(Vector2(x, y)) # so the engine knows where to configure the autotiling

	static func clear(tile_map : TileMap):
		if is_instance_valid(tile_map):
			# Completely clearts the current tilemap
			tile_map.clear()
		else: push_error("TileMap Error: TIlemap not found")

'Delete Files'
func delete_local_file(path_to_file: String) -> void:
	
	if dir.file_exists(path_to_file):
		dir.remove(path_to_file)
		dir.queue_free()
	else:
		push_error('File To Delete Doesnt Exist')
		return




"Calculate the Average of an Array"
# assuming that it's an array of numbers
func calc_average(list: Array):
	if list.pop_front() != null:
		var numerator :int 
		var average : int 
		var denominator : int = list.size() + 1
		if numerator != null and denominator > 2:
			for i in list:
				numerator = numerator + i
			
			#if numerator && denominator != 0:
			average = numerator/denominator
			return average
	else : return

func calc_rand_number()-> int:
	var rando : int = rand_range(2000,10000)
	return rando

"File Checker"
# Global file checking method for DIrectory path and file name/type
# Copied from Wallet's Implementation
func check_files(path_to_dir: String, path_to_file : String)-> bool:
	var FileCheck1=File.new() # checks wallet mnemonic
	var FileDirectory=Directory.new() #deletes all theon reset
	if FileDirectory.dir_exists(path_to_dir):
		#print ("File Exists: ",FileCheck1.file_exists(path_to_file)) # For debug purposes only
		return FileCheck1.file_exists(path_to_file)
	else: return false





		# Updates the raycast to the Enemy"s Direction
static func rotate_pointer(point_direction: Vector2, pointer : Node2D) -> void:
	var temp =rad2deg(atan2(point_direction.x, point_direction.y))
	pointer.rotation_degrees = temp



func restaVectores(v1 : Vector2, v2 : Vector2) -> Vector2: #vector substraction
	return Vector2(v1.x - v2.x, v1.y - v2.y)

func sumaVectores(v1 : Vector2, v2 : Vector2) -> Vector2: #vector sum
	return Vector2(v1.x + v2.x, v1.y + v2.y)

func calc_2d_distance_approx(x : Vector2, y : Vector2) -> int:
	var distance_float : float = 0.0
	var distance_int : int = 0
	distance_float=x.distance_to(y)
	distance_int = abs(distance_float)
	return distance_int

class UI extends Reference:
	"""
	ALL UI Helper Nodes In A Single Class
	"""
	
	static func check_for_broken_links(nodes_array : Array) -> void:
		for i in nodes_array:
			if not is_instance_valid(i):
				push_error(" Node Path Broken : " + str(i))
				print_stack()
	
	'Upscale UI'
	static func upscale_ui(node ,size: Vector2, position : Vector2)-> void:
		#Upscales the UI elements of Nodes
		
		node.set_scale(size) 
		node.set_position(position)
	
	
	




class Downloader extends Node:
	# Unused Downloader Class   
	#
	###Generic File downloader######
	var t = Thread.new()
	
	func _init():
		var arg_bytes_loaded = {"name":"bytes_loaded","type":TYPE_INT}
		var arg_bytes_total = {"name":"bytes_total","type":TYPE_INT}
		add_user_signal("loading",[arg_bytes_loaded,arg_bytes_total])
		var arg_result = {"name":"result","type":TYPE_RAW_ARRAY}
		add_user_signal("loaded",[arg_result])
		pass
		
	func __get(domain : String ,url : String ,port: String,ssl : bool):
		if(t.is_active()):
			return
		t.start(self,"_load",{"domain":domain,"url":url,"port":port,"ssl":ssl})
		 
	func _load(params): # what params?
		var err = 0
		var http = HTTPClient.new()
		err = http.connect(params.domain,params.port,params.ssl)
		 
		while(http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING):
			http.poll()
			OS.delay_msec(100)
		  
		var headers = [
		  "User-Agent: Pirulo/1.0 (Godot)",
		  "Accept: */*"
		 ]
		 
		err = http.request(HTTPClient.METHOD_GET,params.url,headers)
		 
		while (http.get_status() == HTTPClient.STATUS_REQUESTING):
			http.poll()
			OS.delay_msec(500)
		 
		var rb = PoolByteArray()
		if(http.has_response()):
			headers = http.get_response_headers_as_dictionary()
			while(http.get_status()==HTTPClient.STATUS_BODY):
				http.poll()
				var chunk = http.read_response_body_chunk()
				if(chunk.size()==0):
					OS.delay_usec(100)
				else:
					rb = rb+chunk
					call_deferred("_send_loading_signal",rb.size(),http.get_response_body_length())
		  
		call_deferred("_send_loaded_signal")
		http.close()
		return rb
	func _send_loading_signal(l,t):
		emit_signal("loading",l,t)
		pass
		 
	func _send_loaded_signal():
		var r = t.wait_to_finish()
		emit_signal("loaded",r)
		pass







func _exit_tree():
	# Memory Management And removing script warnings
	screenOrientation = 0
	self.queue_free()
	file = null
	dir = null
