extends Button

signal focus(item_name)
signal _button_pressed(item_name)

func _on_mouse_entered():
	emit_signal("focus", text)

func _on_pressed():
	emit_signal("_button_pressed", text)
