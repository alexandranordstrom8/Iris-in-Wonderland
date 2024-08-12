extends Control

@onready var button_sfx = $Audio/Button
@onready var coin_counter = $Counters/HBoxContainer/coin_counter
@onready var skill_menu = $Menus/SkillMenu

var _paused = false

signal hp_changed(amount)
signal sp_changed(amount)
signal coin_count_changed(amount)

# item menu
signal menu_change_sp(amount)
signal menu_change_hp(amount)
signal menu_strawberry
signal menu_key
signal menu_raise_attack
signal menu_shrink
signal menu_grow

func init(coins):
	coin_counter.init(coins)

func _process(_delta):
	skill_menu.get_health_values(int($Counters/HBoxContainer/Panel/VBoxContainer/hp_bar/counter/Label.text), 
	 	int($Counters/HBoxContainer/Panel/VBoxContainer/sp_bar/counter/Label.text))
	
	if visible and not $Menus/DeathMenu.visible:
		if skill_menu.visible:
			if Input.is_action_just_pressed("ui_pause") or Input.is_action_just_pressed("ui_ability"):
				skill_menu.close_window()
		elif Input.is_action_just_pressed("ui_pause"):
			show_menu("PauseMenu")
		elif Input.is_action_just_pressed("ui_ability") and not get_tree().paused:
			Save.get_skills()
			skill_menu.item_list = Save.item_list
			skill_menu.open_window()

func show_menu(m_name):
	var menu = $Menus.get_node(m_name)
	if _paused:
		if m_name == "PauseMenu":
			menu.close_pause_menu()
		menu.hide()
		get_tree().paused = false
	else:
		menu.show()
		get_tree().paused = true
	
	_paused = not _paused

func itemize(item_name, quantity):
	skill_menu.increase_quantity(item_name, quantity)

func save_values():
	Save.set_variables(
		int($Counters/HBoxContainer/coin_counter/Label.text),
		int($Counters/HBoxContainer/Panel/VBoxContainer/hp_bar/counter/Label.text), 
		int($Counters/HBoxContainer/Panel/VBoxContainer/sp_bar/counter/Label.text))

func get_coins():
	return int($Counters/HBoxContainer/coin_counter/Label.text)

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

### pause menu buttons
func _on_menu_continue_pressed():
	button_sfx.play()
	show_menu("PauseMenu")

func _on_menu_main_menu_pressed():
	button_sfx.play()
	get_tree().paused = false
	save_values()
	Save.to_res()
	get_tree().change_scene_to_file(ScenePaths.main_menu_path)

func _on_menu_retry_pressed():
	button_sfx.play()
	get_tree().paused = false
	Save.from_res()
	get_tree().reload_current_scene()

func _on_death_menu_main_menu_pressed():
	button_sfx.play()
	get_tree().paused = false
	get_tree().change_scene_to_file(ScenePaths.main_menu_path)

### skill/item menu
func _on_skill_menu_strawberry():
	emit_signal("menu_strawberry")

func _on_skill_menu_raise_attack():
	emit_signal("menu_raise_attack")

func _on_skill_menu_shrink():
	emit_signal("menu_shrink")

func _on_skill_menu_grow():
	emit_signal("menu_grow")

func _on_skill_menu_benjamin():
	coin_counter.check_max()

func _on_skill_menu_change_sp(amount):
	if amount != 0:
		emit_signal("menu_change_sp", amount)

func _on_skill_menu_change_hp(amount):
	if amount != 0:
		emit_signal("menu_change_hp", amount)

func _on_skill_menu_key_used():
	emit_signal("menu_key")

func _on_skill_menu_caterpillar():
	itemize("Caterpillar Tea", 1)
