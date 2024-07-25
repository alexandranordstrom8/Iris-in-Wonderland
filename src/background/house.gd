extends Node2D

var can_interact : bool = false

@onready var enter_button_area = $EnterButton/Area2D
@onready var enter_button = $EnterButton

signal house_entered

func _ready():
	enter_button.visible = false

func _process(_delta):
	if can_interact and Save.is_small:
		enter_button.visible = true
		if Input.is_action_just_pressed("ui_accept"):
			emit_signal("house_entered")
	else:
		enter_button.visible = false

func _on_area_2d_body_entered(body):
	if body.name == "iris":
		can_interact = true

func _on_area_2d_body_exited(body):
	if body.name == "iris":
		can_interact = false
