extends Panel

@export var item_name : String
@export var cost : int

const DESC_INDEX = 2

signal description(item_name, cost, text)

func _ready():
	$HBoxContainer/Label.text = str(cost)

func _on_mouse_entered():
	emit_signal("description", item_name, cost, Save.item_list[item_name][DESC_INDEX])
