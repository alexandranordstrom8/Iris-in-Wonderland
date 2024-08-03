extends World

var merry_can_interact : bool = false

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

func get_dialogue(_break : bool):
	interface.visible = false
	await get_tree().create_timer(0.1).timeout
	$DialogueWindow.get_text("Merry", _break)

func _input(event):
	if event.is_action_pressed("ui_accept") and merry_can_interact:
		if not Save._save.unlocked_characters.characters["Merry"]:
			Save._save.unlocked_characters.characters["Merry"] = true
			get_dialogue(false)
		else:
			get_dialogue(true)

func _on_exit_button_exit_interacted():
	change_scene(ScenePaths.scene_1)

func _on_exit_button_2_exit_interacted():
	change_scene(ScenePaths.scene_4) 

func _on_exit_button_table_exit_interacted():
	change_scene(ScenePaths.scene_3_table, false)

func _on_bee_timer_timeout():
	add_bee($markers/BeeSpawnPoint.position)

func _on_interact_area_body_entered(body):
	if body.name == "iris":
		merry_can_interact = true

func _on_interact_area_body_exited(body):
	if body.name == "iris":
		merry_can_interact = false
