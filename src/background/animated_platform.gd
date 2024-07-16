class_name AnimatedPlatform
extends Node2D

@onready var _animation = $AnimationPlayer

func _process(_delta):
	_animation.play("slide")
