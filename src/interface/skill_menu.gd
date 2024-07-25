extends Control

const button = "res://Iris-in-Wonderland/src/interface/skill_menu_button.tscn"

var _current_sp : int = 100
var _current_hp : int = 100
var timer_locked : bool = false
var focused_item : String = ""

@onready var cost_label = $Panel/VBoxContainer2/Cost
@onready var desc_label = $Panel/VBoxContainer2/Description
@onready var button_container = $Panel/VBoxContainer/ScrollContainer/VBoxContainer
@onready var img = "res://Iris-in-Wonderland/assets/interface/label_sp2.png"

signal change_sp(amount)
signal change_hp(amount)
signal strawberry
signal raise_attack
signal shrink
signal grow
signal special_used

# list indexes
enum {_NUMBER, _TYPE, _DESCRIPTION, _AVAILABLE, _BUTTON, _HP, _SP}
enum {SKILL, ITEM}

var item_list : Dictionary

var special = ["Strawberry", "Raise Attack", "Small Cookie", "Caterpillar Tea"]

func _ready():
	item_list = Save.item_list
	for item in item_list:
		var _button = preload(button).instantiate()
		button_container.add_child(_button)
		_button.text = item
		_button.focus.connect(_on_button_focus)
		_button._button_pressed.connect(_on_button_pressed)
		item_list[item][_BUTTON] = _button
		
		if not item_list[item][_AVAILABLE]:
			_button.hide()

func _process(_delta):
	disable_buttons()
	if focused_item != "":
		get_description(focused_item)

func get_description(item):
	if item_list[item][_TYPE] == SKILL:
		cost_label.text = "	%s [img]%s[/img]" % [item_list[item][_NUMBER], img]
	else:
		cost_label.text = "	%s in stock" % item_list[item][_NUMBER]
	desc_label.text = "%s" % item_list[item][_DESCRIPTION]

func disable_buttons():
	if Save.is_small:
		item_list["Small Cookie"][_BUTTON].disabled = true
		item_list["Caterpillar Tea"][_BUTTON].disabled = false
	else:
		item_list["Small Cookie"][_BUTTON].disabled = false
		item_list["Caterpillar Tea"][_BUTTON].disabled = true
	
	for item in item_list:
		if (item_list[item][_TYPE] == SKILL and _current_sp < item_list[item][_NUMBER])\
		or (item_list[item][_TYPE] == ITEM and item_list[item][_NUMBER] == 0)\
		or (item_list[item][_HP] > 0 and _current_hp == 100)\
		or (item_list[item][_SP] > 0 and _current_sp == 100):
			item_list[item][_BUTTON].disabled = true
		elif item == "Small Cookie" or item == "Caterpillar Tea":
			pass
		else:
			item_list[item][_BUTTON].disabled = false
	
	if timer_locked:
		item_list["Raise Attack"][_BUTTON].disabled = true

func close_window():
	cost_label.text = ""
	desc_label.text = ""
	focused_item = ""

func get_health_values(hp, sp):
	_current_hp = hp
	_current_sp = sp

func increase_quantity(item_name, quantity):
	item_list[item_name][_NUMBER] += quantity
	if not item_list[item_name][_AVAILABLE]:
		item_list[item_name][_AVAILABLE] = true
		item_list[item_name][_BUTTON].show()

func _on_button_focus(item_name):
	focused_item = item_name

func use_special_item(item_name):
	match item_name:
		"Strawberry":
			emit_signal("strawberry")
		"Raise Attack":
			emit_signal("raise_attack")
		"Small Cookie":
			emit_signal("shrink")
		"Caterpillar Tea":
			emit_signal("grow")
	emit_signal("special_used")

func _on_button_pressed(item_name):
	if item_name in special:
		use_special_item(item_name)
	
	emit_signal("change_hp", item_list[item_name][_HP])
	emit_signal("change_sp", item_list[item_name][_SP])
	
	if item_list[item_name][_TYPE] == ITEM:
		item_list[item_name][_NUMBER] = max(0, item_list[item_name][_NUMBER] - 1)
		get_description(item_name)
		