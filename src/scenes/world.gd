class_name World
extends Node2D

@export var interface: Control
@export var player: CharacterBody2D

var player_hp 
var player_sp

func _ready():
	print("loaded coins %s hp %s sp %s" % [Save.current_coins, Save.current_hp, Save.current_sp])
	init_values()
	#player_hp = player.get_node("hp")
	#player_sp = player.get_node("sp")
	#player_sp.connect("health_changed", interface, "_on_sp_health_changed")
	#player_hp.connect("health_changed", interface, "_on_hp_health_changed")
	#player_hp.connect("not_hurt", interface, "_on_hp_not_hurt")
	#player_hp.connect("hurt", interface, "_on_hp_hurt")
	#player_hp.connect("severely_hurt", interface, "_on_hp_severely_hurt")

func change_scene(prev, new):
	interface.save_values()
	ScenePaths.change_scene(prev, new)
	
func init_values():
	player.init(Save.current_hp, Save.current_sp)
	interface.init(Save.current_coins)
