class_name AnimatedCharacter
extends CharacterBody2D

@export var dialogue_key : String

var animation_name = "default"
var can_interact = false

@onready var _animation = $AnimatedSprite2D

signal show_text(dialogue_key)

func _ready():
	var world = get_tree().current_scene
	show_text.connect(world._on_show_text)

func change_animation(_name):
	animation_name = _name
	
func _physics_process(_delta):
	_animation.play(animation_name)
	
func _on_area_2d_body_entered(body):
	if body.name == "iris":
		can_interact = true
		
func _on_area_2d_body_exited(body):
	if body.name == "iris":
		can_interact = false
