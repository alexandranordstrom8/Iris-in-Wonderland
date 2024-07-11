extends Control

@onready var button_sfx = $Audio/Button

var paused = false

signal init(coins, hp, sp)
signal hp_changed(amount)
signal sp_changed(amount)
signal coin_count_changed(amount)

func _process(_delta):
	if Input.is_action_just_pressed("ui_pause"):
		show_menu("PauseMenu")

func show_menu(m_name):
	var menu = $Menus.get_node(m_name)
	if paused:
		menu.hide()
		Engine.time_scale = 1
	else:
		menu.show()
		Engine.time_scale = 0
	
	paused = not paused

func save_values():
	Save.set_variables(
		int($Counters/HBoxContainer/coin_counter/HBoxContainer/Label.text),
		int($Counters/HBoxContainer/Panel/VBoxContainer/hp_bar/counter/Label.text), 
		int($Counters/HBoxContainer/Panel/VBoxContainer/sp_bar/counter/Label.text))
	
### health signals
func _on_hp_health_changed(amount):
	emit_signal("hp_changed", amount)
	
func _on_sp_health_changed(amount):
	emit_signal("sp_changed", amount)

func _on_coin_coin_collected():
	emit_signal("coin_count_changed", 1)

func _on_iris_hp_depleted():
	$Audio/GameOverSFX.play()
	show_menu("DeathMenu") 

func _on_hp_not_hurt():
	$Counters/border_red.visible = false
	$Counters/border_yellow.visible = false 

func _on_hp_hurt():
	$Counters/border_red.visible = false
	$Counters/border_yellow.visible = true

func _on_hp_severely_hurt():
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
	#Engine.time_scale = 1
	### reload current scene

func _on_world_prev_values(coins, hp, sp):
	emit_signal("init", coins, hp, sp)

func _on_world_save_values():
	save_values()
