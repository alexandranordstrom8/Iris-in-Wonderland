extends Control

@onready var char_animations = $bg/Marker2D/iris_rig/Sprite2D/AnimationPlayer
@onready var button_sfx = $Audio/Button
@onready var purr_sfx = $Audio/Purring

func _ready():
	char_animations.play("idle")
	
func _process(delta):
	$ParallaxBackground.scroll_base_offset += Vector2(-100, 100) * delta

func _on_play_pressed():
	button_sfx.play()
	ScenePaths.change_scene(ScenePaths.scene_0, ScenePaths.scene_0)

func _on_options_pressed():
	button_sfx.play()

func _on_credits_pressed():
	button_sfx.play()

func _on_quit_pressed():
	get_tree().quit()

func _on_area_2d_mouse_entered():
	purr_sfx.play()
	char_animations.play("purr")

func _on_area_2d_mouse_exited():
	purr_sfx.stop()
	char_animations.play("idle")
