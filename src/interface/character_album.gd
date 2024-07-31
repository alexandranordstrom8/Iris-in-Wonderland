extends Control

@onready var description = $Panel/Description
@onready var iris_panel = $Panel/GridContainer/Iris

func _ready():
	var panels = get_tree().get_nodes_in_group("char_grid")
	for c in panels:
		c.show_desc.connect(_on_show_desc)
		c.hide_desc.connect(_on_hide_desc)
	iris_panel.show_desc.connect(_on_show_desc)
	iris_panel.hide_desc.connect(_on_hide_desc)
	get_chars()

func get_chars():
	var panels = get_tree().get_nodes_in_group("char_grid")
	for c in panels:
		c.check_visible()

func _on_show_desc(char_name, unlocked):
	char_name = String(char_name)
	description.get_node(char_name).show_desc(unlocked)

func _on_hide_desc(char_name):
	char_name = String(char_name)
	description.get_node(char_name).hide_desc()
