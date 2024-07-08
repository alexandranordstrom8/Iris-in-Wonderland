class_name Enemy
extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -600.0
const ACTION_COOLDOWN = 1.6

var freeze_movement: bool
var can_interact: bool
var target_pos: Vector2
@export var hp: Health

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal attacked(dmg)
signal hp_depleted()

func _ready():
	pass
	
func set_can_interact(value):
	can_interact = value

func set_freeze_movement(value):
	freeze_movement = value
	
func set_target_pos(pos):
	target_pos = pos
	
func _process(delta):
	velocity.y += gravity * delta

func _on_health_health_depleted():
	queue_free()
	
func _on_area_2d_body_entered(_body):
	pass

func _on_area_2d_body_exited(_body):
	pass

func _on_iris_damage_dealt(amount):
	hp.take_damage(amount)

func _on_iris_knock_back(_velocity, _dir, _xpos):
	pass

func _on_iris_knock_back_stop():
	pass
