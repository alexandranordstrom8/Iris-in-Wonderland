extends World

@onready var default_marker = $markers/default

func _ready():
	super()
	player.position = default_marker.position
	$character/player/DefaultCamera.position = default_marker.position

func _process(_delta):
	pass
