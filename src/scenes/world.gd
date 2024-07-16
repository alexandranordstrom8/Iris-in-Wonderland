class_name World
extends Node2D

@export var interface: Control
@export var player: CharacterBody2D

func _ready():
	print("loaded coins %s hp %s sp %s" % [Save.current_coins, Save.current_hp, Save.current_sp])
	init_values()

func change_scene(prev, new):
	interface.save_values()
	ScenePaths.change_scene(prev, new)
	
func init_values():
	player.init(Save.current_hp, Save.current_sp)
	interface.init(Save.current_coins)
