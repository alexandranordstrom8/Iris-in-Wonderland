extends Node

var loaded = false

var current_coins = 0
var current_hp = 100
var current_sp = 100
var prev_scene: String # load previous scene after game is restarted

func _ready():
	pass 
	### läs in från en fil med tidigare spardata, 
	### annars börja från första scenen

func set_variables(coins, hp, sp):
	current_coins = coins
	current_hp = hp
	current_sp = sp
	print("variables set, coins %s hp %s sp %s" % [current_coins, current_hp, current_sp])
