extends AnimatedCharacter

func _on_iris_interacted():
	Save._save.unlocked_characters.characters["Isabell"] = true
