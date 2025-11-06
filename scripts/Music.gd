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
# (3) Implement Car sfx
# (4) Car accelerate sfx and music play subsytem needs proper audit
# (5) Optimize all car sfx to be as low res as possible
# 
# *************************************************

extends Node

class_name Music

export (bool) var Enabled : bool
export (bool) var sfx_on : bool
#export (int) var volume # volume controller code is not yet written
export (int) var play_back_position : int
export (int) var track_length : int

export(String, FILE, "*.ogg") var music_track : String = ""


# Audio FX Enumeration
# Matches The Audio Fx Layout Arrangement In Audio Bus Layout
enum FX {AMPLIFY, BAND_LIMIT_FILTER, BAND_PASS_FILTER, CAPTURE, CHORUS, COMPRESSOR, 
DELAY, DISTORTION, EQ, EQ10, EQ21, EQ6, FILTER, HIGH_PASS_FILTER, HIGH_SHELF_FILTER,
LIMITER, LOW_PASS_FILTER, LOW_SHELF_FILTER, NOTCH_FILTER, PANNER, PHASER, PITCH_SHIFT,
RECORD, REVERB, SPECTRUM_ANALYSER, STERIO_ENCHANCE
 }

export (Dictionary) var default_playlist = {
	0: "res://music/songs/beaach sex chike san.ogg",
	1:"res://music/songs/Moya.ogg",
	2:"res://music/songs/Seabase X - No Waves.ogg"

}
export (Dictionary) var carSfx = {0: "res://music/sfx/car-acceleration-inside-car.ogg"}
export (Dictionary) var citySfx = {0: ""}

onready var stream : String = "" 

# music and sfx players
onready var A : AudioStreamPlayer = get_node("A")
onready var B : AudioStreamPlayer = get_node("B")
onready var C : AudioStreamPlayer = get_node("C")
onready var D : AudioStreamPlayer = get_node("D")

onready var my_nodes = [A,B,C,D]


onready var current_track : String
onready var music_bus_2 = AudioServer.get_bus_index(B.bus)
onready var music_bus = AudioServer.get_bus_index(A.bus)

onready var transitions = $AnimationPlayer

# singleton pointers
#onready var safe_Utils = get_node("/root/Utils")

func _ready():
	
	if Enabled :
		randomize() # randomise the engine's seed generator
		"Default Music"
		# bug:
		# (1) does not shuffle music
		music_track = shuffle(default_playlist)
		#play(music_track) #Not needed for release
		play_track(music_track)
		
	if !Enabled:
		A.stop()
	pass

func carAccelerate():
	#C.play(load(carSfx[0]));
	
	#C.stream = load(carSfx[0])
	#C.play()
	pass


"""
MUSIC SHUFFLE
"""
# Shuffles A Dictionary, Returns a string
static func shuffle (playlist : Dictionary) -> String:
	var track = int(rand_range(-1,playlist.size())) #selects a random track number
	#print_debug("selected Item After Shuffle: ",playlist[track]) # for debugging purposes only
	return playlist[track]

static func shuffle_array(_fx : Array) -> int : # selects a random number of an array
	var sel = int (rand_range(-1,_fx.size()))
	return _fx[sel]


func play(_stream: String):
	#print_stack()
	# Features
	# Preloads Randomised Tracks into A and B music streamer and transitions 
	# Between Both Tracks using animation player BtoA and AtoB once each track finishes
	# Randomises The Playlist once A or B finished playing
	# Emits a signal once each track finished playing for all AudioStreamPlayers
	# (1) loads a track
	# (2) Loads B Track
	#it bugs out when the music track node is added to a scene
	# Bugs:
	# (1) Method is called Twice During process funtion and loads 2 different music tracks
	# (2) This method triggers the audio to play at another pitch?
	#print_stack()
	#print_debug('Stream:', _stream,'Music Track',music_track,"Current Track: ", current_track)
	if _stream == null: return # guard clauses
	if _stream.empty(): return
	if _stream.empty() : # debug
		push_error('Music stream is null, fix')
		
	if !Enabled : return
	# note: track a is for triggering sfx, track b is for playing audio
	# bugs:
	# (1) bugs out on playing the second track
	if current_track == "a":
		print_debug("Load Track A: ", _stream)
		B.stream = load(_stream) #invalid funtion load, cannot convert arguement from nil to string
		transitions.play("AtoB")
		current_track = "a"
		Enabled = true
		#Music_streamer_3.stop() #hacky fix
		return
	
	if current_track == "b" or current_track.empty(): # current track is initially empty, then it's set to a
		print_debug("Load Track B: ", current_track, "/", _stream)
		A.stream = load(_stream)
		transitions.play("BtoA")
		current_track = "b" # current track is set to a
		Enabled = true
		return
	# settings saving should be done in controls scene
	
	#print_debug('Play Music setting debug: ', enable) #For Debug purposes only



func play_sfx(list : Dictionary): #a separate bus channel for sfx using dictionary playlist
	if sfx_on== true:
		var sfx : String = shuffle(list) 
		
		C.stream = load(sfx)
		C.play()
		#print_debug ('playing sfx: ',sfx.get_file()) #works
		yield(get_tree().create_timer(0.8), "timeout")
		C.stop()

func play_track(_track : String): 
	#for playing single sample tracks
	#_track is a pointer to the music file path
	#if _track != null  and Music_streamer_2 != null :
	D.set_stream ( load (_track)) #Children Scripts should not load the soundtracks
	D.play(0.0)
	print_debug ('playing sfx: ',_track.get_file()) # for debug purposes only
	#yield(get_tree().create_timer(0.8), "timeout")
	#D.stop()


func _exit_tree(): 
	#safe_Utils.MemoryManagement.queue_free_array(my_nodes)
	
	
	# memory management
	default_playlist.clear()
	carSfx.clear()
	citySfx.clear()

# temporarily depreicated for an update
func get_random_sound_effect() -> int :
	
	var selected_sound_fx= shuffle_array(FX.values())
	return selected_sound_fx


func set_sound_effect(fx_ : int, state : bool):
	# Exportable Function To Set Sound Effect From Any Scene
	if FX.values().has(fx_):
		AudioServer.set_bus_effect_enabled(music_bus,fx_,state)
	else:
		push_error("Selected Sound FX is Beyond The Scope Of Usable SFX")



# Music Finished Playing
func _on_Music_music_finished():
	print_debug("music funished playing B")
	randomize()
	music_track = shuffle(default_playlist)
	play(music_track)
