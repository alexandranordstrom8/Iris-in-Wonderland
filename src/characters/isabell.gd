extends AnimatedCharacter

func _on_iris_interacted():
	if can_interact:
		Save._save.unlocked_characters.characters["Isabell"] = true
		emit_signal("show_text", dialogue_key)
