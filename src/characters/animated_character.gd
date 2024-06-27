class_name AnimatedCharacter
extends CharacterBody2D

@onready var _animation = $AnimatedSprite2D
var animation_name = "default"

func change_animation(_name):
	animation_name = _name

func _physics_process(_delta):
	if _animation:
		_animation.play(animation_name)
