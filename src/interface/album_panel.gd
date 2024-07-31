class_name AlbumPanel
extends Panel

@export var unlocked : bool = false

signal show_desc(_name, unlocked)
signal hide_desc(_name)

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	if self.name == "Iris":
		_set_visible()
	else:
		check_visible()

func check_visible():
	if Save._save.unlocked_characters.characters[self.name]:
		_set_visible()
	else:
		unlocked = false
		get_node("TextureRect").visible = false
		get_node("Label").visible = true

func _set_visible():
	unlocked = true
	get_node("TextureRect").visible = true
	get_node("Label").visible = false

func _on_mouse_entered():
	emit_signal("show_desc", self.name, unlocked)

func _on_mouse_exited():
	emit_signal("hide_desc", self.name)
