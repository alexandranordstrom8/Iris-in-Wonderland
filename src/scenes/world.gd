class_name World
extends Node2D

@export var interface: Control
@export var player: CharacterBody2D
@export var transition: Node2D

func _ready():
	Save.current_scene = scene_file_path
	print("loaded coins %s hp %s sp %s" % [Save.current_coins, Save.current_hp, Save.current_sp])
	init_values()

func change_scene(new):
	call_deferred("_change_scene_deferred", new)

func _change_scene_deferred(new):
	interface.save_values()
	ScenePaths.change_scene(scene_file_path, new)
	
func init_values():
	player.init(Save.current_hp, Save.current_sp)
	interface.init(Save.current_coins)
