extends Panel

@export var item_name : String
@export var cost : int

@onready var _modulate = self.modulate

const DESC_INDEX = 2

signal description(item_name, cost, text)

func _ready():
	$HBoxContainer/Label.text = str(cost)

func reset():
	modulate = _modulate

func _on_mouse_entered():
	modulate = Color.WHITE
	emit_signal("description", item_name, cost, Save.item_list[item_name][DESC_INDEX])

func _on_mouse_exited():
	#reset()
	pass
