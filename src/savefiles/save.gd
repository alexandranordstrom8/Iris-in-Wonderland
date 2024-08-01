extends Node

var _save : SaveGame

# save data
var current_coins = 0
var coin_max = 50
var item_max = 10
var current_hp = 100
var current_sp = 100
var prev_scene : String
var current_scene : String
var is_small : bool = false
var table_empty : bool = false

enum health_status {NOT_HURT, HURT, SEVERELY_HURT}
enum {SKILL, ITEM}
const TYPE = 1
const AVAILABLE = 3

var item_list = {
	"Strawberry" : [0, ITEM, "Rolling strawberry, deals damage when its health is depleted", false, null, 0, 0],
	"Raise Attack" : [20, SKILL, "Raises attack damage for 5 seconds", true, null, 0, -20],
	"Purr" : [5, SKILL, "Recover 5 hp", true, null, 5, -5],
	"Benjamin's Blessing" : [50, SKILL, "Allows you to carry twice the amount of coins and items", false, null, 0, -50],
	"Golden Key" : [0, ITEM, "Can open any door", false, null, 0, 0],
	"Small Cookie" : [0, ITEM, "Makes you shrink", false, null, 0, 0],
	"Caterpillar Tea" : [0, ITEM, "Makes you grow", false, null, 0, 0],
	"Cake" : [0, ITEM, "Heals 10 sp", false, null, 0, 10],
	"Apple" : [0, ITEM, "Heals 10 hp", false, null, 10, 0],
	"Pink Heart" : [0, ITEM, "Heals 5 hp", false, null, 5, 0],
	"Blue Heart" : [0, ITEM, "Heals 5 sp", false, null, 0, 5],
}

var _skills = {
	"Benjamin" : "Benjamin's Blessing",
	}

func _ready():
	if SaveGame.exists():
		_save = SaveGame.load_file()
		from_res()
		get_skills()
	else:
		_save = SaveGame.new()
		_save.write_to_file()

# used by interface
func set_variables(coins, hp, sp):
	current_coins = coins
	current_hp = hp
	current_sp = sp

func get_skills():
	for char_name in _skills:
		if _save.unlocked_characters.characters[char_name]:
			item_list[_skills[char_name]][AVAILABLE] = true

func from_res():
	var p = _save.player_values
	var i = _save.inventory
	
	current_coins = p.current_coins
	current_hp = p.current_hp
	current_sp = p.current_sp
	coin_max = p.coin_max
	item_max = p.item_max
	current_scene = p.current_scene
	prev_scene = p.prev_scene
	is_small = p.is_small
	
	for item in i.item_list:
		item_list[item][AVAILABLE] = i.item_list[item][i.AVAILABLE]
		item_list[item][0] = i.item_list[item][i.QTY]

func to_res():
	var p = _save.player_values
	var i = _save.inventory
	
	p.current_coins = current_coins
	p.current_hp = current_hp
	p.current_sp = current_sp
	p.coin_max = coin_max
	p.item_max = item_max
	p.current_scene = current_scene
	p.prev_scene = prev_scene
	p.is_small = is_small
	
	for item in i.item_list:
		i.item_list[item][i.AVAILABLE] = item_list[item][AVAILABLE]
		i.item_list[item][i.QTY] = item_list[item][0]
	
	print_save()
	_save.write_to_file()

func print_save():
	var p = _save.player_values
	var i = _save.inventory
	print(p.current_coins, p.current_hp, p.current_sp)
	print(p.is_small, p.coin_max, p.item_max)
	print(i.item_list)
	print(_save.unlocked_characters.characters)

func reset():
	current_coins = 0
	current_hp = 100
	current_sp = 100
	coin_max = 50
	item_max = 10
	current_scene = ""
	prev_scene = ""
	is_small = false
	table_empty = false
	
	for i in item_list:
		if item_list[i][TYPE] == ITEM:
			item_list[i][0] = 0
			item_list[i][AVAILABLE] = false
	
	to_res()
