extends World

@onready var cam0 = $camera/cam_0
@onready var cam3 = $camera/cam_3

func _ready():
	super()
	match Save.prev_scene:
		ScenePaths.scene_0:
			player.position = $markers/Marker2D_0.position
			cam0.make_current()
			player.get_node("Marker2D").scale.x = -1
		ScenePaths.scene_3:
			player.position = $markers/Marker2D_3.position
			cam3.make_current()
		ScenePaths.scene_4:
			player.position = $markers/Marker2D_4.position
			cam3.make_current()
		ScenePaths.scene_6:
			player.position = $markers/Marker2D_6.position
			cam3.make_current()
		_:
			player.position = $markers/debug.position
			cam3.make_current()

func _on_exit_button_exit_interacted():
	change_scene(ScenePaths.scene_0)

func _on_exit_button_2_exit_interacted():
	change_scene(ScenePaths.scene_3)

func _on_exit_button_3_exit_interacted():
	change_scene(ScenePaths.scene_4)

func _on_house_house_entered():
	change_scene(ScenePaths.scene_6)

func _on_bee_timer_timeout():
	add_bee($markers/BeeSpawnPoint.position)
