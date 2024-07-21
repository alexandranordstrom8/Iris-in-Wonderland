extends World

@onready var cam1 = $camera/cam_1
@onready var cam2 = $camera/cam_2
@onready var cam3 = $camera/cam_3
@onready var card_wall_back = $platforms/wall
@onready var card_wall_front = $fg/wall

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

func _on_button_area_body_entered(body):
	if body.is_in_group("character"):
		var tween = get_tree().create_tween().set_parallel(true)
		tween.tween_property(card_wall_back, "position", $markers/wall_back_pos2.position, 0.3)
		tween.tween_property(card_wall_front, "position", $markers/wall_front_pos2.position, 0.3)

func _on_button_area_body_exited(body):
	if body.is_in_group("character"):
		var tween = get_tree().create_tween().set_parallel(true)
		tween.tween_property(card_wall_back, "position", $markers/wall_back_pos1.position, 0.3)
		tween.tween_property(card_wall_front, "position", $markers/wall_front_pos1.position, 0.3)
