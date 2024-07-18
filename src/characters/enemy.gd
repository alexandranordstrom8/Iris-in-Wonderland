class_name Enemy
extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -600.0
const ACTION_COOLDOWN = 1.6

var freeze_movement: bool
var can_interact = {"iris": false}
var target_pos: Vector2
@export var hp: Health

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal attacked(amount, can_interact_list, pos, dir)
signal hp_depleted()

func _process(delta):
	velocity.y += gravity * delta
	move_and_slide()
	
func set_can_interact(entity, value):
	can_interact[entity] = value
	
func get_can_interact(entity):
	return can_interact[entity]

func set_freeze_movement(value):
	freeze_movement = value
	if value == true:
		velocity.x = 0
	
func set_target_pos(pos):
	target_pos = pos

func _on_health_health_depleted():
	queue_free()
	
func _on_area_2d_body_entered(body):
	if body.get_parent().name == "character" and not body == self:
		set_can_interact(body.name, true)

func _on_area_2d_body_exited(body):
	if body.get_parent().name == "character" and not body == self:
		set_can_interact(body.name, false)

func _on_iris_damage_dealt(amount):
	if can_interact["iris"]:
		hp.take_damage(amount)

# damage from other enemies
func _on_enemy_attacked(amount, _can_interact, _position, _dir):
	if _can_interact.get(self.name):
		hp.take_damage(amount)

func _on_iris_knock_back(_velocity, dir, xpos):
	if can_interact["iris"]:
		# player facing right, self on left
		if dir == 1 and xpos > position.x:
			pass
		# player facing left, self on right
		elif dir == -1 and xpos < position.x:
			pass
		else:
			velocity.x = int(_velocity * 0.5)

func _on_iris_knock_back_stop():
	set_freeze_movement(false)
	velocity.x = 0
