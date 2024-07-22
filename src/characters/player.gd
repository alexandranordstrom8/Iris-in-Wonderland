extends Node2D

@onready var interface = $ui/Interface
@onready var skillmenu = $ui/Interface/Menus/SkillMenu
@onready var iris = $iris

signal strawberry_used(pos, dir)

func _on_interface_menu_change_hp(amount):
	iris.get_node("hp").heal(amount)

func _on_interface_menu_change_sp(amount):
	if amount < 0:
		iris.get_node("sp").take_damage(-1 * amount)
	else:
		iris.get_node("sp").heal(amount)

func _on_interface_menu_raise_attack():
	$Timer.start()
	skillmenu.timer_locked = true
	iris.dmg_multiplier = 2

func _on_interface_menu_strawberry():
	emit_signal("strawberry_used", iris.position, iris.get_node("Marker2D").scale.x)

func _on_timer_timeout():
	skillmenu.timer_locked = false
	iris.dmg_multiplier = 1
