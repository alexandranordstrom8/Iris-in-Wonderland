extends Control

signal hp_changed(hp)
signal sp_changed(sp)

func _on_hp_health_changed(health):
	emit_signal("hp_changed", health)
	
func _on_sp_health_changed(health):
	emit_signal("sp_changed", health)

func _on_iris_hp_depleted():
	pass 
