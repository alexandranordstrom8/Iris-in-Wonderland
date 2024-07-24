extends Node2D

var can_enter : bool = false

@onready var enter_button_area = $EnterButton/Area2D
@onready var enter_button = $EnterButton

signal house_entered

func _ready():
	enter_button.visible = false

func set_can_enter(value : bool):
	can_enter = value

func _process(_delta):
	if can_enter and Input.is_action_just_pressed("ui_accept"):
		emit_signal("house_entered")

func _on_area_2d_body_entered(body):
	if body.name == "iris" and can_enter:
		enter_button.visible = true

func _on_area_2d_body_exited(body):
	if body.name == "iris":
		enter_button.visible = false
