extends Node

var loaded = false

var current_coins = 0
var current_hp = 100
var current_sp = 100
var prev_scene : String
var current_scene : String

# list indexes
enum {_NUMBER, _TYPE, _DESCRIPTION, _AVAILABLE, _BUTTON, _HP, _SP}
enum {SKILL, ITEM}

var item_list = {
	"Strawberry" : [100, ITEM, "Rolling strawberry, deals damage when its health is depleted", true, null, 0, 0],
	"Raise Attack" : [20, SKILL, "Raises attack damage for 5 seconds", true, null, 0, -20],
	"Purr" : [5, SKILL, "Recover 5 hp", true, null, 5, -5],
	"Cake" : [2, ITEM, "Heals 10 sp", true, null, 0, 10],
	"Apple" : [2, ITEM, "Heals 10 hp", true, null, 10, 0],
}

enum health_status {NOT_HURT, HURT, SEVERELY_HURT}

func set_variables(coins, hp, sp, items):
	current_coins = coins
	current_hp = hp
	current_sp = sp
	item_list = items
