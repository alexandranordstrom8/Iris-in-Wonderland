extends World

@onready var default_marker = $markers/default
@onready var caterpillar = $character/Caterpillar

func _ready():
	super()
	$character/player.ignore_scale = true
	player.position = default_marker.position
	player.get_node("Marker2D").scale.x = -1
	$character/player/DefaultCamera.position = default_marker.position

func _on_exit_area_body_entered(body):
	if body.name == "iris":
		change_scene(ScenePaths.scene_1, false)

func _on_exit_button_exit_interacted():
	change_scene(ScenePaths.scene_1)
