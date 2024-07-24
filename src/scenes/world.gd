class_name World
extends Node2D

@export var interface: Control
@export var player: CharacterBody2D

@onready var enemies = get_tree().get_nodes_in_group("enemy")
@onready var coins = get_tree().get_nodes_in_group("coins")

func _ready():
	Save.current_scene = scene_file_path
	init_values()
	$character/player.strawberry_used.connect(_on_player_strawberry_used)

func change_scene(new):
	call_deferred("_change_scene_deferred", new)

func _change_scene_deferred(new):
	interface.save_values()
	ScenePaths.change_scene(scene_file_path, new)
	
func init_values():
	player.init(Save.current_hp, Save.current_sp)
	interface.init(Save.current_coins)
	
func _on_enemy_get_position(target_name, enemy_name):
	if String(target_name) == "iris":
		target_name = "player/iris"
	else:
		target_name = String(target_name)
	var target = $character.get_node(target_name)
	var _enemy = $character.get_node(String(enemy_name))
	_enemy.set_target_pos(target.position)

func _on_item_itemized(item_name, quantity):
	interface.itemize(item_name, quantity)

func _on_player_strawberry_used(pos, dir):
	var _strawberry = preload("res://Iris-in-Wonderland/src/characters/strawberry.tscn").instantiate()
	$character.add_child(_strawberry)
	_strawberry.dir = dir * 2
	_strawberry.position = pos
	_strawberry.velocity.y = -500
