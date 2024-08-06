extends HBoxContainer

func animate(old, new, is_hp):
	if get_tree().paused:
		$TextureProgressBar.value = new
		return
	
	var tween = get_tree().create_tween()
	tween.tween_property($TextureProgressBar, "value", new, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	if old > new and is_hp:
		var tween2 = get_tree().create_tween()
		var pos = $counter.position
		tween2.tween_property($counter, "position", Vector2(pos.x, pos.y - 20), 0.1)
		tween2.tween_property($counter, "position", pos, 0.1)

#player hp
func _on_interface_hp_changed(hp):
	animate($TextureProgressBar.value, hp, 1)
	$counter/Label.text = str(hp)

#player sp
func _on_interface_sp_changed(sp):
	animate($TextureProgressBar.value, sp, 0)
	$counter/Label.text = str(sp)
