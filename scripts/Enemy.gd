extends Node

# Exported variables so you can set them in the Godot editor
export (PackedScene) var rock
export (PackedScene) var gems

var player_obj = null

# Short spawn intervals
var start_delay = 5.0
var spawn_interval = 5.5

var time_left = 10.0

# Long spawn intervals
var start_delay_2 = 5.0
var spawn_interval_2 = 15.0

# Randomized Force Variables
var min_speed = 20.0
var max_speed = 50.0
var max_torque = 10.0

func _ready():
	# Find the player node
	player_obj = get_node_or_null("/root/PathToYourPlayer") # <- Change this path to the correct one!
	
	if player_obj == null:
		player_obj = get_tree().get_root().find_node("Player", true, false)

	# Start timers for spawning rocks and gems
	var rock_timer = Timer.new()
	rock_timer.wait_time = spawn_interval
	rock_timer.one_shot = false
	add_child(rock_timer)
	rock_timer.start(start_delay)
	rock_timer.connect("timeout", self, "_on_throw_rocks")

	var gems_timer = Timer.new()
	gems_timer.wait_time = spawn_interval_2
	gems_timer.one_shot = false
	add_child(gems_timer)
	gems_timer.start(start_delay_2)
	gems_timer.connect("timeout", self, "_on_throw_gems")


func _process(delta):
	time_left -= delta
	if time_left < 0:
		self.position = player_position_in_front()
		time_left = 10.0

func _on_throw_rocks():
	if rock and player_obj:
		var instance = rock.instance()
		instance.global_transform.origin = player_position_above()
		add_child(instance)
		
		if instance.has_method("apply_impulse"):
			instance.apply_impulse(Vector3.ZERO, random_force())

		if instance.has_method("apply_torque_impulse"):
			instance.apply_torque_impulse(Vector3(
				random_torque(),
				random_torque(),
				random_torque()
			))

func _on_throw_gems():
	if gems and player_obj:
		var instance = gems.instance()
		instance.global_transform.origin = player_position_above()
		add_child(instance)

func player_position_above():
	var spawn_pos = player_obj.position
	spawn_pos.y += 20.0
	return spawn_pos

func player_position_in_front():
	var spawn_pos = player_obj.global_transform.origin
	spawn_pos.z -= 20.0
	return spawn_pos

func random_force():
	return Vector3.DOWN * rand_range(min_speed, max_speed)

func random_torque():
	return rand_range(-max_torque, max_torque)
