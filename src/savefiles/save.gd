extends Node

var loaded = false

var current_coins = 0
var current_hp = 100
var current_sp = 100
var prev_scene : String
var current_scene : String

enum health_status {NOT_HURT, HURT, SEVERELY_HURT}
enum {SKILL, ITEM, DESCRIPTION}

var item_list = {
	"Strawberry" : [100, ITEM, "Rolling strawberry, deals damage when its health is depleted", true, null, 0, 0],
	"Raise Attack" : [20, SKILL, "Raises attack damage for 5 seconds", true, null, 0, -20],
	"Purr" : [5, SKILL, "Recover 5 hp", true, null, 5, -5],
	"Cake" : [0, ITEM, "Heals 10 sp", true, null, 0, 10],
	"Apple" : [0, ITEM, "Heals 10 hp", true, null, 10, 0],
	"Pink Heart" : [0, ITEM, "Heals 5 hp", true, null, 5, 0],
	"Blue Heart" : [0, ITEM, "Heals 5 sp", true, null, 0, 5],
}

func set_variables(coins, hp, sp, items):
	current_coins = coins
	current_hp = hp
	current_sp = sp
	item_list = items
