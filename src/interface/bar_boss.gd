extends TextureProgressBar

func _on_hp_health_changed(health):
	value = health

func _on_hp_max_health_changed(maximum):
	max_value = maximum
	value = max_value
