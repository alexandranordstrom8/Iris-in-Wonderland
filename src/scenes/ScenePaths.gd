extends Node

var scene_0 = "res://Iris-in-Wonderland/src/scenes/0.tscn"
var scene_1 = "res://Iris-in-Wonderland/src/scenes/1.tscn"
var scene_2 = "res://Iris-in-Wonderland/src/scenes/2.tscn"

func change_scene(prev, new):
	Save.prev_scene = prev
	get_tree().change_scene_to_file(new)