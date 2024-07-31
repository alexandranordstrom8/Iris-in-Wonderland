extends CanvasLayer

@export_file("*json") var scene_text_file: String

var scene_text : Dictionary
var selected = []
var sprite : Panel

@onready var text_label = $DialogueBox/Box/Label
@onready var _char_name = $DialogueBox/Box/Name/Label
@onready var box = $DialogueBox

signal finished

func _ready():
	self.hide()
	scene_text = load_scene_text()
	var world = get_tree().current_scene
	finished.connect(world._on_dialogue_finished)
	set_process(false)

func load_scene_text():
	if FileAccess.file_exists(scene_text_file):
		var file = FileAccess.open(scene_text_file, FileAccess.READ)
		var _file = JSON.new()
		_file.parse(file.get_as_text())
		return _file.get_data()

func _get_text():
	text_label.text = selected.pop_front()
	set_process(true)

func next_line():
	if selected.size() > 0:
		_get_text()
	else:
		finish()

func finish():
	self.hide()
	_char_name.text = ""
	text_label.text = ""
	sprite.hide()
	get_tree().paused = false
	set_process(false)
	emit_signal("finished")

func _process(_delta):
	if visible and Input.is_action_just_pressed("ui_accept"):
		next_line()

func get_text(char_name):
	_char_name.text = char_name
	sprite = box.get_node(char_name)
	sprite.show()
	get_tree().paused = true
	selected = scene_text[char_name].duplicate()
	_get_text()
	self.show()
