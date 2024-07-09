extends Control

signal hp_changed(hp)
signal sp_changed(sp)
signal coin_count_changed(amount)

func _on_hp_health_changed(health):
	emit_signal("hp_changed", health)
	
func _on_sp_health_changed(health):
	emit_signal("sp_changed", health)

func _on_coin_coin_collected():
	emit_signal("coin_count_changed", 1)

func _on_iris_hp_depleted():
	pass 

func _on_hp_not_hurt():
	$border_red.visible = false
	$border_yellow.visible = false 

func _on_hp_hurt():
	$border_red.visible = false
	$border_yellow.visible = true

func _on_hp_severely_hurt():
	$border_red.visible = true
	$border_yellow.visible = false 
