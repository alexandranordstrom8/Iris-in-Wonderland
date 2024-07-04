class_name Enemy
extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -600.0
const ACTION_COOLDOWN = 0.9

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal attacked(dmg)
signal hp_depleted()

func _ready():
	pass
	
func _process(delta):
	velocity.y += gravity * delta
