class_name World
extends Node2D

@export var interface: Control
@export var player: CharacterBody2D

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
	
func _on_enemy_get_position(target_name, enemy_name):
	if target_name == String("iris"):
		target_name = "player/iris"
	var target = $character.get_node(target_name)
	var _enemy = $character.get_node(String(enemy_name))
	_enemy.set_target_pos(target.position)
