extends Node2D

const SCALE_DEFAULT = Vector2(0.75, 0.75)
const SCALE_SMALL = Vector2(0.25, 0.25)

@onready var interface = $ui/Interface
@onready var skillmenu = $ui/Interface/Menus/SkillMenu
@onready var iris = $iris

@export var ignore_scale : bool = false

signal strawberry_used(pos, dir)
signal key_used

func _ready():
	if Save.is_small and not ignore_scale:
		iris.scale = SCALE_SMALL
	else:
		iris.scale = SCALE_DEFAULT
	if ignore_scale:
		interface.skill_menu.in_enclosed_space = true

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

func _on_interface_menu_shrink():
	Save.is_small = true
	var tween = get_tree().create_tween()
	tween.tween_property(iris, "scale", SCALE_SMALL, 0.5)

func _on_interface_menu_grow():
	if not ignore_scale:
		Save.is_small = false
		var tween = get_tree().create_tween()
		tween.tween_property(iris, "scale", SCALE_DEFAULT, 0.5)

func _on_interface_menu_key():
	emit_signal("key_used")
