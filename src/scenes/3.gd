extends World

@onready var cam1 = $camera/cam_1
@onready var cam4 = $camera/cam_4

func _ready():
	super()
	Save.table_empty = false
	match Save.prev_scene:
		ScenePaths.scene_1:
			player.position = $markers/Marker2D_1.position
			player.get_node("Marker2D").scale.x = -1
			cam1.make_current()
		ScenePaths.scene_4:
			player.position = $markers/Marker2D_4.position
			cam4.make_current()
		ScenePaths.scene_3_table:
			Save.table_empty = true
			player.position = $markers/Table.position
			cam4.make_current()
		_:
			player.position = $markers/Table.position
			cam4.make_current()

func _on_exit_button_exit_interacted():
	change_scene(ScenePaths.scene_1)

func _on_exit_button_2_exit_interacted():
	change_scene(ScenePaths.scene_4) 

func _on_exit_button_table_exit_interacted():
	change_scene(ScenePaths.scene_3_table, false)

func _on_bee_timer_timeout():
	add_bee($markers/BeeSpawnPoint.position)
