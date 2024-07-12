extends World

@onready var camera = $camera/PanningCamera
@onready var camera2 = $camera/PanningCamera2
@onready var ref_marker = $markers/ref
@onready var player = $character/iris
@onready var player_marker = $character/iris/Marker2D
@onready var spawn_marker = $markers/spawn

var started = false
var can_interact = false

func _ready():
	interface.visible = false
	if Save.prev_scene == ScenePaths.scene_1:
		camera2.make_current()
		camera.position = spawn_marker.position
		player.position = spawn_marker.position
	else:
		camera.make_current()
		player_marker.scale.x = -1
	camera.look_down_possible = false

func _process(_delta):
	if can_interact and Input.is_action_just_pressed("ui_accept"):
		change_scene(ScenePaths.scene_0, ScenePaths.scene_1)

func _on_area_2d_body_entered(body):
	if body.name == "iris" and not started:
		camera.set_panning_target(ref_marker.position, 30)
		started = true

func _on_exit_body_entered(body):
	if body.name == "iris":
		can_interact = true

func _on_area_2d_body_exited(body):
	if body.name == "iris":
		can_interact = false

func _on_glow_body_entered(body):
	if body.name == "iris":
		interface.visible = true
