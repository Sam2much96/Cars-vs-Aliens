extends WorldEnvironment

# to do:
# (1) weather particle fx


#define the weather simple state machine
var WeatherAnim : Array = ["DAY", "NIGHT", "RAIN"]

#world scene manager
onready var WeatherManager : AnimationPlayer = $AnimationPlayer

#get time data from the game hud

func _ready():
	
	# set weather to random for testing
	randomize()
	var random_weather = WeatherAnim[randi() % WeatherAnim.size()]
	WeatherManager.play(random_weather)
