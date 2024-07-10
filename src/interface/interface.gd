extends Control

var paused = false

signal hp_changed(hp)
signal sp_changed(sp)
signal coin_count_changed(amount)

func _process(delta):
	if Input.is_action_just_pressed("ui_pause"):
		show_menu("PauseMenu")

func show_menu(name):
	var menu = $Menus.get_node(name)
	if paused:
		menu.hide()
		Engine.time_scale = 1
	else:
		menu.show()
		Engine.time_scale = 0
	
	paused = not paused
	
func _on_hp_health_changed(health):
	emit_signal("hp_changed", health)
	
func _on_sp_health_changed(health):
	emit_signal("sp_changed", health)

func _on_coin_coin_collected():
	emit_signal("coin_count_changed", 1)

func _on_iris_hp_depleted():
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

func _on_menu_continue_pressed():
	show_menu("PauseMenu")

func _on_menu_options_pressed():
	pass 

func _on_menu_main_menu_pressed():
	get_tree().change_scene_to_file("res://Iris-in-Wonderland/src/interface/main_menu.tscn")

func _on_menu_retry_pressed():
	pass 
