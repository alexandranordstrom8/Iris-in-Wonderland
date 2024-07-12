class_name World
extends Node2D

@export var interface: Control

signal prev_values(coins, hp, sp)
signal save_values()

func _ready():
	print("loaded coins %s hp %s sp %s" % [Save.current_coins, Save.current_hp, Save.current_sp])
	emit_signal("prev_values", Save.current_coins, Save.current_hp, Save.current_sp)

func change_scene(prev, new):
	interface.save_values()
	ScenePaths.change_scene(prev, new)
