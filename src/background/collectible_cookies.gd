extends "res://Iris-in-Wonderland/src/background/collectible.gd"

func _process(_delta):
	if $PickUpLabel.visible and Input.is_action_just_pressed("ui_accept"):
		emit_signal("itemized", item_name, quantity)
