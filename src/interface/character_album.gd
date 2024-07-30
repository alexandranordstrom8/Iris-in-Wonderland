extends Control

func _ready():
	get_chars()

func get_chars():
	var panels = get_tree().get_nodes_in_group("char_grid")
	for c in panels:
		if Save._save.unlocked_characters.characters[c.name]:
			c.get_node("TextureRect").visible = true
			c.get_node("Label").visible = false
		else:
			c.get_node("TextureRect").visible = false
			c.get_node("Label").visible = true
