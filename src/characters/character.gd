class_name Character
extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -600.0

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	velocity.y += gravity * delta
