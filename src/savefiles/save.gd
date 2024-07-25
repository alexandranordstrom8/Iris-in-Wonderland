extends Node

# save data
var current_coins = 10
var current_hp = 100
var current_sp = 100
var prev_scene : String
var current_scene : String
var is_small : bool = false

enum health_status {NOT_HURT, HURT, SEVERELY_HURT}
enum {SKILL, ITEM, DESCRIPTION}
const TYPE = 1
const AVAILABLE = 3

var item_list = {
	"Strawberry" : [100, ITEM, "Rolling strawberry, deals damage when its health is depleted", true, null, 0, 0],
	"Raise Attack" : [20, SKILL, "Raises attack damage for 5 seconds", true, null, 0, -20],
	"Purr" : [5, SKILL, "Recover 5 hp", true, null, 5, -5],
	"Golden Key" : [0, ITEM, "Can open any door", false, null, 0, 0],
	"Small Cookie" : [1, ITEM, "Makes you shrink", true, null, 0, 0],
	"Caterpillar Tea" : [1, ITEM, "Makes you grow", true, null, 0, 0],
	"Cake" : [0, ITEM, "Heals 10 sp", false, null, 0, 10],
	"Apple" : [0, ITEM, "Heals 10 hp", false, null, 10, 0],
	"Pink Heart" : [0, ITEM, "Heals 5 hp", false, null, 5, 0],
	"Blue Heart" : [0, ITEM, "Heals 5 sp", false, null, 0, 5],
}

func set_variables(coins, hp, sp, items):
	current_coins = coins
	current_hp = hp
	current_sp = sp
	item_list = items

func reset():
	current_coins = 0
	current_hp = 100
	current_sp = 100
	current_scene = ""
	prev_scene = ""
	is_small = false
	
	for i in item_list:
		if item_list[i][TYPE] == ITEM:
			item_list[i][0] = 0
			item_list[i][AVAILABLE] = false
