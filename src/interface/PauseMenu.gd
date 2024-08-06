extends Control

signal continue_pressed
signal options_pressed
signal main_menu_pressed
signal retry_pressed

func _ready():
	$Options.hide()
	if has_node("character_album"):
		$character_album.hide()

func _on_continue_pressed():
	emit_signal("continue_pressed")

func _on_options_pressed():
	emit_signal("options_pressed")
	$Button.play()
	$Options.show()

func _on_main_menu_pressed():
	emit_signal("main_menu_pressed")

func _on_retry_pressed():
	emit_signal("retry_pressed")

func _on_options_button_pressed():
	$Button.play()
	$Options.hide()

func _on_album_pressed():
	$Button.play()
	$character_album.get_chars()
	$character_album.show()

func _on_album_button_pressed():
	$Button.play()
	$character_album.hide()

func close_pause_menu():
	$character_album.hide()

func _on_controls_button_toggled(toggled_on):
	if toggled_on:
		$Control.show()
	else:
		$Control.hide()
