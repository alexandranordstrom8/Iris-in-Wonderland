extends Button

signal focus(button, item_name)
signal _button_pressed(button, item_name)

func _on_mouse_entered():
	emit_signal("focus", self, text)

func _on_pressed():
	emit_signal("_button_pressed", self, text)
