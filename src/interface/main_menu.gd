extends Control

@onready var char_animations = $bg/Marker2D/iris_rig/Sprite2D/AnimationPlayer
@onready var button_sfx = $Audio/Button
@onready var purr_sfx = $Audio/Purring
@onready var confirmation = $Options/Panel2/confirm
@onready var deletion_message = $Options/Panel2/DeletionMessage

func _ready():
	char_animations.play("idle")
	$Credits.hide()
	$Options.hide()
	
func _process(delta):
	$ParallaxBackground.scroll_base_offset += Vector2(-100, 100) * delta

func _on_play_pressed():
	button_sfx.play()
	match Save.current_scene:
		"":
			ScenePaths.change_scene(ScenePaths.scene_0, ScenePaths.scene_0, false)
		_:
			ScenePaths.change_scene(Save.prev_scene, Save.current_scene)

func _on_options_pressed():
	button_sfx.play()
	$Options.show()
	confirmation.hide()
	deletion_message.hide()
	$Main.hide()

func _on_credits_pressed():
	button_sfx.play()
	$Credits.show()
	$Main.hide()

func _on_quit_pressed():
	get_tree().quit()

func _on_area_2d_mouse_entered():
	purr_sfx.play()
	char_animations.play("purr")

func _on_area_2d_mouse_exited():
	purr_sfx.stop()
	char_animations.play("idle")

func _on_credits_button_pressed():
	button_sfx.play()
	$Credits.hide()
	$Main.show()

func _on_options_button_pressed():
	button_sfx.play()
	$Options.hide()
	$Main.show()

func _on_delete_menu_button_pressed():
	confirmation.show()

func _on_delete_button_pressed():
	Save.reset()
	confirmation.hide()
	deletion_message.show()


