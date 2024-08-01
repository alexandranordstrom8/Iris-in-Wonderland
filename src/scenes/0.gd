extends World

@onready var camera = $camera/PanningCamera
@onready var camera2 = $camera/PanningCamera2
@onready var ref_marker = $markers/ref
@onready var spawn_marker = $markers/spawn
@onready var default_marker = $markers/default
@onready var pos2d = player.get_node("Marker2D")

var started = false

func _ready():
	if Save.prev_scene == ScenePaths.scene_1:
		super()
		interface.visible = true
		camera2.make_current()
		camera.position = spawn_marker.position
		player.position = spawn_marker.position
	else:
		init_values()
		interface.visible = false
		camera.make_current()
		player.position = default_marker.position
		pos2d.scale.x = -1
		$character/player.strawberry_used.connect(_on_player_strawberry_used)
	camera.look_down_possible = false

func _on_area_2d_body_entered(body):
	if body.name == "iris" and not started:
		camera.set_panning_target(ref_marker.position, 30)
		started = true

func _on_glow_body_entered(body):
	if body.name == "iris":
		interface.visible = true

func _on_exit_button_exit_interacted():
	change_scene(ScenePaths.scene_1)
