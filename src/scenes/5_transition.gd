extends World

@onready var cam = $character/player/DefaultCamera
@onready var bg = $ParallaxBackground/ParallaxLayer

func _ready():
	init_values()
	cam.free_movement = true
	cam.set_panning_target($markers/cam_ref.position, true)

func _on_bounce_area_body_entered(body):
	if body.name == "iris":
		cam.free_movement = false
		bg.motion_scale = Vector2(0, 2)

func _on_boundary_body_entered(body):
	if body.name == "iris":
		player.set_process(false)
		change_scene(ScenePaths.scene_5)
