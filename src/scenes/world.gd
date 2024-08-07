class_name World
extends Node2D

@export var interface: Control
@export var player: CharacterBody2D

@onready var enemies = get_tree().get_nodes_in_group("enemy")
@onready var coins = get_tree().get_nodes_in_group("coins")

const item_sfx_path = "res://Iris-in-Wonderland/src/interface/item_sfx.tscn"
var item_sfx : AudioStreamPlayer

const strawberry_path = "res://Iris-in-Wonderland/src/characters/strawberry.tscn"
const bee_path = "res://Iris-in-Wonderland/src/characters/bee.tscn"
const coin_path = "res://Iris-in-Wonderland/src/interface/coin.tscn"

func _ready():
	Save.current_scene = scene_file_path
	Save.to_res()
	init_values()

func change_scene(new, show_loading_screen=true):
	call_deferred("_change_scene_deferred", new, show_loading_screen)

func _change_scene_deferred(new, show_loading_screen=true):
	interface.save_values()
	ScenePaths.change_scene(scene_file_path, new, show_loading_screen)
	
func init_values():
	player.init(Save.current_hp, Save.current_sp)
	interface.init(Save.current_coins)
	$character/player.strawberry_used.connect(_on_player_strawberry_used)
	item_sfx = preload(item_sfx_path).instantiate()
	get_tree().current_scene.add_child(item_sfx)
	
func _on_enemy_get_position(target_name, enemy_name):
	var _enemy = $character.get_node(String(enemy_name))
	if String(target_name) == "iris":
		target_name = "player/iris"
	else:
		target_name = String(target_name)
	var target = $character.get_node(target_name)
	_enemy.set_target_pos(target.position)

func _on_bowl_heal(amount):
	player.get_node("hp").heal(amount)
	player.get_node("sp").heal(amount)

func _on_item_itemized(item_name, quantity):
	if item_sfx:
		item_sfx.play()
	interface.itemize(item_name, quantity)

func _on_player_strawberry_used(pos, dir):
	var _strawberry = preload(strawberry_path).instantiate()
	$character.add_child(_strawberry)
	_strawberry.dir = dir * 2
	_strawberry.position = pos
	_strawberry.velocity.y = -500

func add_bee(pos):
	var _bee = preload(bee_path).instantiate()
	$character.add_child(_bee)
	_bee.position = pos

func _on_bee_new_target(bee):
	var spawn = $markers/BeeSpawnPoint.position
	var boundary = $markers/BeeBoundary.position
	bee.target_pos = Vector2(randi_range(spawn.x, boundary.x), randi_range(spawn.y, 600))

func _on_bee_spawn_coin(coin_position):
	var _coin = preload(coin_path).instantiate()
	$collectibles.add_child(_coin)
	_coin.position = coin_position
	_coin.value = 5

func _on_show_text(char_name):
	interface.visible = false
	await get_tree().create_timer(0.1).timeout
	$DialogueWindow.get_text(char_name)

func _on_dialogue_finished():
	interface.visible = true
