extends Node

var loaded = false

var current_coins = 0
var current_hp = 100
var current_sp = 100
var prev_scene : String
var current_scene : String
var item_list : Dictionary

enum health_status {NOT_HURT, HURT, SEVERELY_HURT}

func set_variables(coins, hp, sp, items):
	current_coins = coins
	current_hp = hp
	current_sp = sp
	item_list = items
	print("variables set, coins %s hp %s sp %s" % [current_coins, current_hp, current_sp])
