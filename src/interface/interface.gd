extends Control

@onready var button_sfx = $Audio/Button
@onready var coin_counter = $Counters/HBoxContainer/coin_counter
@onready var skill_menu = $Menus/SkillMenu

var paused = false

signal hp_changed(amount)
signal sp_changed(amount)
signal coin_count_changed(amount)

# item menu
signal menu_change_sp(amount)
signal menu_change_hp(amount)
signal menu_strawberry
signal menu_raise_attack

func init(coins):
	coin_counter.init(coins)

func _process(_delta):
	skill_menu.get_health_values(int($Counters/HBoxContainer/Panel/VBoxContainer/hp_bar/counter/Label.text), 
	 	int($Counters/HBoxContainer/Panel/VBoxContainer/sp_bar/counter/Label.text))
	
	if visible and not $Menus/DeathMenu.visible:
		if skill_menu.visible:
			if Input.is_action_just_pressed("ui_pause") or Input.is_action_just_pressed("ui_ability"):
				skill_menu.hide()
				skill_menu.close_window()
		elif Input.is_action_just_pressed("ui_pause"):
			show_menu("PauseMenu")
		elif Input.is_action_just_pressed("ui_ability") and not $Menus/PauseMenu.visible:
			skill_menu.show()

func show_menu(m_name):
	var menu = $Menus.get_node(m_name)
	if paused:
		menu.hide()
		Engine.time_scale = 1
	else:
		menu.show()
		Engine.time_scale = 0
	
	paused = not paused

func itemize(item_name, quantity):
	skill_menu.increase_quantity(item_name, quantity)

func save_values():
	Save.set_variables(
		int($Counters/HBoxContainer/coin_counter/HBoxContainer/Label.text),
		int($Counters/HBoxContainer/Panel/VBoxContainer/hp_bar/counter/Label.text), 
		int($Counters/HBoxContainer/Panel/VBoxContainer/sp_bar/counter/Label.text),
		skill_menu.item_list)

func get_coins():
	return int($Counters/HBoxContainer/coin_counter/HBoxContainer/Label.text)

### health signals
func _on_iris_hp_changed(amount):
	emit_signal("hp_changed", amount)

func _on_iris_sp_changed(amount):
	emit_signal("sp_changed", amount)

func _on_coin_coin_collected(amount):
	emit_signal("coin_count_changed", amount)

func _on_iris_hp_depleted():
	$Audio/GameOverSFX.play()
	show_menu("DeathMenu") 

func _on_iris_health_status(value):
	if value == Save.health_status.NOT_HURT:
		$Counters/border_red.visible = false
		$Counters/border_yellow.visible = false 
	elif value == Save.health_status.HURT:
		$Counters/border_red.visible = false
		$Counters/border_yellow.visible = true
	elif value == Save.health_status.SEVERELY_HURT:
		$Counters/border_red.visible = true
		$Counters/border_yellow.visible = false 

### menu buttons
func _on_menu_continue_pressed():
	button_sfx.play()
	show_menu("PauseMenu")

func _on_menu_options_pressed():
	button_sfx.play()

func _on_menu_main_menu_pressed():
	button_sfx.play()
	Engine.time_scale = 1
	save_values()
	get_tree().change_scene_to_file("res://Iris-in-Wonderland/src/interface/main_menu.tscn")

func _on_menu_retry_pressed():
	button_sfx.play()
	Engine.time_scale = 1
	get_tree().reload_current_scene()

### skill/item menu
func _on_skill_menu_strawberry():
	emit_signal("menu_strawberry")

func _on_skill_menu_raise_attack():
	emit_signal("menu_raise_attack")

func _on_skill_menu_change_sp(amount):
	if amount != 0:
		emit_signal("menu_change_sp", amount)

func _on_skill_menu_change_hp(amount):
	if amount != 0:
		emit_signal("menu_change_hp", amount)

func _on_skill_menu_special_used():
	skill_menu.close_window()
	skill_menu.hide()
