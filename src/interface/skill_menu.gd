extends Control

const button = "res://Iris-in-Wonderland/src/interface/skill_menu_button.tscn"

var _current_sp : int = 100
var _current_hp : int = 100

@onready var cost_label = $Panel/VBoxContainer2/Cost
@onready var desc_label = $Panel/VBoxContainer2/Description
@onready var button_container = $Panel/VBoxContainer/ScrollContainer/VBoxContainer
@onready var img = "res://Iris-in-Wonderland/assets/interface/label_sp2.png"

signal change_sp(amount)
signal change_hp(amount)
signal strawberry
signal raise_attack

# list indexes
enum {_NUMBER, _TYPE, _DESCRIPTION, _AVAILABLE, _BUTTON, _HP, _SP}
enum {SKILL, ITEM}

var item_list = {
	"Strawberry" : [0, ITEM, "Rolling strawberry, deals damage when its health is depleted", true, null, 0, 0],
	"Raise Attack" : [20, SKILL, "Raises attack damage for 3 seconds", true, null, 0, -20],
	"Purr" : [5, SKILL, "Recover 5 hp", true, null, 5, -5],
	"Cake" : [2, ITEM, "Heals 10 sp", true, null, 0, 10],
	"Apple" : [2, ITEM, "Heals 10 hp", true, null, 10, 0],
}

var special = ["Strawberry", "Raise Attack"]

func _ready():
	for item in item_list:
		if item_list[item][_AVAILABLE]:
			var _button = load(button).instantiate()
			button_container.add_child(_button)
			_button.text = item
			_button.focus.connect(_on_button_focus)
			_button._button_pressed.connect(_on_button_pressed)
			item_list[item][_BUTTON] = _button

func _process(_delta):
	disable_buttons()

func get_description(item):
	if item_list[item][_TYPE] == SKILL:
		cost_label.text = "	%s [img]%s[/img]" % [item_list[item][_NUMBER], img]
	else:
		cost_label.text = "	%s in stock" % item_list[item][_NUMBER]
	desc_label.text = "%s" % item_list[item][_DESCRIPTION]

func disable_buttons():
	for item in item_list:
		if (item_list[item][_TYPE] == SKILL and _current_sp < item_list[item][_NUMBER])\
		or (item_list[item][_TYPE] == ITEM and item_list[item][_NUMBER] == 0)\
		or (item_list[item][_HP] > 0 and _current_hp == 100)\
		or (item_list[item][_SP] > 0 and _current_sp == 100):
			item_list[item][_BUTTON].disabled = true
		else:
			item_list[item][_BUTTON].disabled = false

func close_window():
	cost_label.text = " "
	desc_label.text = " "

func get_health_values(hp, sp):
	_current_hp = hp
	_current_sp = sp

func increase_quantity(item_name, quantity):
	item_list[item_name][_NUMBER] += quantity

func _on_button_focus(_button, item_name):
	get_description(item_name)

func use_special_item(item_name):
	if item_name == "Strawberry":
		emit_signal("strawberry")
	if item_name == "Raise Attack":
		emit_signal("raise_attack")

func _on_button_pressed(_button, item_name):
	if item_name in special:
		use_special_item(item_name)
	
	emit_signal("change_hp", item_list[item_name][_HP])
	emit_signal("change_sp", item_list[item_name][_SP])
	
	if item_list[item_name][_TYPE] == ITEM:
		item_list[item_name][_NUMBER] = max(0, item_list[item_name][_NUMBER] - 1)
		get_description(item_name)
		
