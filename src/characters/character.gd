class_name Character
extends CharacterBody2D

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const FLOOR_NORMAL = Vector2.UP
var _velocity = Vector2.ZERO

func _physics_process(delta):
	_velocity.y += gravity * delta
