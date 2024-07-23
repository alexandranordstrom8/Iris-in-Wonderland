extends Control

var _current_coins : int = 15
var selected : String
var cost : int
var amount : int = 0

@onready var description = $Panel/VBoxContainer/Description
@onready var amount_label = $Panel/VBoxContainer/HBoxContainer/HBoxContainer/amount
@onready var cost_label = $Panel/VBoxContainer/HBoxContainer/Panel/cost

@onready var subtract_button = $Panel/VBoxContainer/HBoxContainer/HBoxContainer/subtract
@onready var add_button = $Panel/VBoxContainer/HBoxContainer/HBoxContainer/add
@onready var buy_button = $Panel/VBoxContainer/HBoxContainer/buy

signal shop_closed(current_coins)
signal item_bought(item, amount, cost)

func _process(_delta):
	var total_cost = cost * amount
	
	if amount == 0:
		buy_button.disabled = true
	elif total_cost > _current_coins:
		buy_button.disabled = true
		cost_label.set("theme_override_colors/font_color", Color.LIGHT_CORAL)
		cost_label.set("theme_override_colors/font_outline_color", Color.RED)
	else:
		buy_button.disabled = false
		cost_label.set("theme_override_colors/font_color", Color.WHITE)
	
	amount_label.text = str(amount)
	cost_label.text = "%s/%s " % [str(total_cost), str(_current_coins)]
	
	if Input.is_action_just_pressed("ui_pause"):
		emit_signal("shop_closed", _current_coins)

func get_coins(coins):
	_current_coins = coins

func _on_shop_panel_description(item_name, _cost, text):
	subtract_button.disabled = false
	add_button.disabled = false
	amount = 0
	selected = item_name
	cost = _cost
	description.text = text

func _on_subtract_pressed():
	amount -= 1
	amount = max(0, amount)

func _on_add_pressed():
	amount += 1

func _on_exit_button_pressed():
	emit_signal("shop_closed", _current_coins)

func _on_buy_pressed():
	_current_coins -= amount * cost
	emit_signal("item_bought", selected, amount)
