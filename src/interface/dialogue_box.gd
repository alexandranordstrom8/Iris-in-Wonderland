extends Control

@export var _name : String
@export var _text : String

@onready var name_label = $Box/Name/Label
@onready var text_label = $Box/Label

func _ready():
	name_label.text = _name
	text_label.text = _text
	var sprite = get_node(_name)
	if sprite:
		sprite.show()

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_next_text()

func get_next_text():
	print("get text")
	pass
