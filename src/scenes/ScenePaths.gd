extends Node

const loading_screen_path = "res://Iris-in-Wonderland/src/interface/loading_screen.tscn"
const main_menu_path = "res://Iris-in-Wonderland/src/interface/main_menu.tscn"

var scene_0 = "res://Iris-in-Wonderland/src/scenes/0.tscn"
var scene_1 = "res://Iris-in-Wonderland/src/scenes/1.tscn"
var scene_2 = "res://Iris-in-Wonderland/src/scenes/2.tscn"
var scene_3 = "res://Iris-in-Wonderland/src/scenes/3.tscn"
var scene_3_table = "res://Iris-in-Wonderland/src/scenes/3_table.tscn"
var scene_4 = "res://Iris-in-Wonderland/src/scenes/4.tscn"
var scene_5 = "res://Iris-in-Wonderland/src/scenes/5.tscn"
var scene_5_transition = "res://Iris-in-Wonderland/src/scenes/5_transition.tscn"
var scene_6 = "res://Iris-in-Wonderland/src/scenes/6.tscn"

func change_scene(prev, new, show_loading_screen=true):
	Save.prev_scene = prev
	if show_loading_screen:
		var loading_screen = preload(loading_screen_path).instantiate()
		loading_screen.next_scene = new
		get_tree().current_scene.add_child(loading_screen)
	else:
		get_tree().change_scene_to_file(new)
