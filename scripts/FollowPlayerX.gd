extends Node

# Follows the Player Objects  + An Offset

export (NodePath) var player_path
export (Vector3) var offset = Vector3()

onready var player = null

func _ready():
	if player_path != null:
		player = get_node(player_path)

func _process(delta):
	if player:
		self.position = player.position + offset
