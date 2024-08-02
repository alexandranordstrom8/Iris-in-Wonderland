extends World

@onready var key_ui = $platforms/stairs/DoorArea/Sprite2D
@onready var door_open = $platforms/stairs/Sprite2D/Sprite2D2

@onready var cam0 = $camera/cam_0
@onready var cam3 = $camera/cam_3
@onready var cam5 = $camera/cam_5

func _ready():
	super()
	key_ui.visible = false
	door_open.visible = false
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
		ScenePaths.scene_5:
			player.position = $markers/Marker2D_5.position
			cam5.make_current()
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

func _on_door_area_body_entered(body):
	if body.name == "iris":
		interface.skill_menu.next_to_door = true
		key_ui.visible = true

func _on_door_area_body_exited(body):
	if body.name == "iris":
		interface.skill_menu.next_to_door = false
		key_ui.visible = false

func _on_player_key_used():
	key_ui.visible = false
	door_open.visible = true
	await get_tree().create_timer(0.3).timeout
	change_scene(ScenePaths.scene_5_transition, false)

func _on_special_dialogue(char_name):
	interface.visible = false
	await get_tree().create_timer(0.1).timeout
	$bird_sfx.play()
	$DialogueWindowSpecial.get_text(char_name)
	player.get_node("hp").take_damage(10)
