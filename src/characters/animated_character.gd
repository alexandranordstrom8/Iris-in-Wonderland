class_name AnimatedCharacter
extends CharacterBody2D

@onready var _animation = $AnimatedSprite2D

func change_animation(animation):
	_animation.play(animation)

func _physics_process(_delta):
	if _animation:
		_animation.play("idle")
