class_name World
extends Node2D

signal prev_values(coins, hp, sp)

func _ready():
	print("loaded coins %s hp %s sp %s" % [Save.current_coins, Save.current_hp, Save.current_sp])
	emit_signal("prev_values", Save.current_coins, Save.current_hp, Save.current_sp)

func _process(_delta):
	pass
