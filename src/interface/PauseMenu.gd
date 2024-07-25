extends Control

signal continue_pressed
signal options_pressed
signal main_menu_pressed
signal retry_pressed

func _ready():
	$Options.hide()

func _on_continue_pressed():
	emit_signal("continue_pressed")

func _on_options_pressed():
	emit_signal("options_pressed")
	$Options.show()

func _on_main_menu_pressed():
	emit_signal("main_menu_pressed")

func _on_retry_pressed():
	emit_signal("retry_pressed")

func _on_options_button_pressed():
	$Options/Button.play()
	$Options.hide()
