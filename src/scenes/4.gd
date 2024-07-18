extends World

@onready var cam1 = $camera/cam_1
@onready var cam2 = $camera/cam_2
@onready var cam3 = $camera/cam_3

func _ready():
	super()
	match Save.prev_scene:
		ScenePaths.scene_1:
			player.get_node("Marker2D").scale.x = -1
			player.position = $markers/Marker2D_1.position
			cam1.make_current()
		ScenePaths.scene_3:
			player.get_node("Marker2D").scale.x = -1
			player.position = $markers/Marker2D_3.position
			cam3.make_current()
		ScenePaths.scene_2:
			player.position = $markers/Marker2D_2.position
			cam2.make_current()
		_:
			player.get_node("Marker2D").scale.x = -1
			player.position = $markers/debug.position
			cam3.make_current()

func _on_exit_button_exit_interacted():
	change_scene(ScenePaths.scene_1)

func _on_exit_button_2_exit_interacted():
	change_scene(ScenePaths.scene_2)

func _on_exit_button_3_exit_interacted():
	change_scene(ScenePaths.scene_3)
