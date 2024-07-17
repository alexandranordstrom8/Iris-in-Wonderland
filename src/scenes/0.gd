extends World

@onready var camera = $camera/PanningCamera
@onready var camera2 = $camera/PanningCamera2
@onready var ref_marker = $markers/ref
@onready var player_marker = $character/iris/Marker2D
@onready var spawn_marker = $markers/spawn

var started = false

func _ready():
	if Save.prev_scene == ScenePaths.scene_1:
		super()
		interface.visible = true
		camera2.make_current()
		camera.position = spawn_marker.position
		player.position = spawn_marker.position
	else:
		interface.visible = false
		camera.make_current()
		player_marker.scale.x = -1
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
