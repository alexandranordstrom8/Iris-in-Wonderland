extends AnimatedCharacter

signal shop_opened

func _process(_delta):
	if can_interact and Input.is_action_just_pressed("ui_accept"):
		if not Save._save.unlocked_characters.characters["Shopkeeper"]:
			Save._save.unlocked_characters.characters["Shopkeeper"] = true
			emit_signal("show_text", dialogue_key)
		else:
			emit_signal("shop_opened")
