class_name Enemy
extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -600.0
const ACTION_COOLDOWN = 1.6

var freeze_movement: bool
var can_interact = {"iris": false}
var detected = {"iris": false}
var target_pos: Vector2
var chase : bool = false

@export var hp: Health
@export var damage : int

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal attacked(amount, can_interact_list, pos, dir)
signal get_position(target_name, enemy_name)
signal hp_depleted()

func _ready():
	add_to_group("character")
	add_to_group("enemy")
	var world = get_tree().current_scene
	var enemies = world.get_tree().get_nodes_in_group("enemy")
	
	world.player.damage_dealt.connect(_on_iris_damage_dealt)
	world.player.knock_back.connect(_on_iris_knock_back)
	world.player.knock_back_stop.connect(_on_iris_knock_back_stop)
	
	self.attacked.connect(world.player._on_enemy_attacked)
	self.get_position.connect(world._on_enemy_get_position)
	
	for enemy in enemies:
		if enemy != self:
			enemy.attacked.connect(_on_enemy_attacked)
			self.attacked.connect(enemy._on_enemy_attacked)

func _process(delta):
	velocity.y += gravity * delta
	move_and_slide()
	
func set_can_interact(entity, value):
	can_interact[entity] = value

func set_freeze_movement(value):
	freeze_movement = value
	if value == true:
		velocity.x = 0
	
func set_target_pos(pos):
	target_pos = pos

func detected_empty():
	for entity in detected:
		if detected[entity]:
			emit_signal("get_position", entity, self.name)
			return false
	return true

func _on_health_health_depleted():
	queue_free()
	
func _on_hitbox_body_entered(body):
	if body.is_in_group("character") and not body == self:
		set_can_interact(body.name, true)

func _on_hitbox_body_exited(body):
	if body.is_in_group("character") and not body == self:
		set_can_interact(body.name, false)
		emit_signal("get_position", body.name, self.name)

func _on_detection_area_body_entered(body):
	if body.is_in_group("character") and not body == self:
		chase = true
		target_pos = body.position
		detected[body.name] = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("character") and not body == self:
		detected[body.name] = false
		if detected_empty():
			chase = false

func _on_hp_damage_taken():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.LIGHT_CORAL, 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)

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
