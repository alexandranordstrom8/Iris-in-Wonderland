extends Control

@onready var char_animations = $bg/Marker2D/iris_rig/Sprite2D/AnimationPlayer

func _ready():
	char_animations.play("idle")
	
func _process(delta):
	$ParallaxBackground.scroll_base_offset += Vector2(-100, 100) * delta

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Iris-in-Wonderland/src/scenes/world.tscn")

func _on_options_pressed():
	pass 

func _on_quit_pressed():
	get_tree().quit()

