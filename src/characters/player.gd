extends Node2D

@onready var interface = $ui/Interface
@onready var iris = $iris

func _on_interface_menu_change_hp(amount):
	iris.get_node("hp").heal(amount)

func _on_interface_menu_change_sp(amount):
	if amount < 0:
		iris.get_node("sp").take_damage(-1 * amount)
	else:
		iris.get_node("sp").heal(amount)

func _on_interface_menu_raise_attack():
	pass # Replace with function body.

func _on_interface_menu_strawberry():
	pass # Replace with function body.
