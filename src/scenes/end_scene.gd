extends Control

var can_return = false

@onready var iris_anim = $iris/AnimationPlayer
@onready var title_anim = $Panel2/AnimationPlayer
@onready var title = $Panel2

signal change_anim

func _ready():
	title.visible = false

func _input(event):
	if event.is_action_pressed("ui_accept") and can_return:
		get_tree().change_scene_to_file(ScenePaths.main_menu_path)

func _on_change_anim():
	iris_anim.play("2")
	title_anim.play("1")
	can_return = true
