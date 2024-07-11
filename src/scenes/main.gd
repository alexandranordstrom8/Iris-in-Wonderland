extends Node

@onready var main_menu = "res://Iris-in-Wonderland/src/interface/main_menu.tscn"

func _ready():
	get_tree().change_scene_to_file(main_menu)

func load_level(level_name : String):
	var path = "res://Iris-in-Wonderland/src/scenes/%s.tscn" % level_name
	### check if exists
	get_tree().change_scene_to_file(path)
