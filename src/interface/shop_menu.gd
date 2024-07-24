extends Control

var _current_coins : int = 0
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
	
	if total_cost > _current_coins:
		buy_button.disabled = true
		add_button.disabled = true
		cost_label.set("theme_override_colors/font_color", Color.LIGHT_CORAL)
		cost_label.set("theme_override_colors/font_outline_color", Color.RED)
	else:
		buy_button.disabled = false
		cost_label.set("theme_override_colors/font_color", Color.WHITE)
		cost_label.set("theme_override_colors/font_outline_color", null)
	if amount == 0:
		buy_button.disabled = true
		subtract_button.disabled = true
	
	amount_label.text = str(amount)
	cost_label.text = "%s/%s" % [str(total_cost), str(_current_coins)]
	
	if Input.is_action_just_pressed("ui_pause") and visible:
		close_shop()

func get_coins(coins):
	_current_coins = coins

func close_shop():
	emit_signal("shop_closed", _current_coins)
	amount = 0
	description.text = ""
	add_button.disabled = true
	buy_button.disabled = true
	subtract_button.disabled = true

func _on_shop_panel_description(item_name, _cost, text):
	add_button.disabled = false
	amount = 0
	selected = item_name
	cost = _cost
	description.text = text

func _on_subtract_pressed():
	amount -= 1
	amount = max(0, amount)
	if selected == "Golden Key" and amount == 0:
		add_button.disabled = false

func _on_add_pressed():
	amount += 1
	subtract_button.disabled = false
	if selected == "Golden Key" and amount == 1:
		add_button.disabled = true

func _on_exit_button_pressed():
	close_shop()

func _on_buy_pressed():
	_current_coins -= amount * cost
	emit_signal("item_bought", selected, amount)
