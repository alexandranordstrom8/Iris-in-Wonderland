extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -600.0
const ACTION_COOLDOWN = 0.8

const SCRATCH_DMG = 10
const DASH_DMG = 1
var dmg_multiplier = 1
var can_deal_damage = 1

var _timer = ACTION_COOLDOWN
var freeze_movement = false
var attacking = false

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animations = $Marker2D/iris_rig/Sprite2D/AnimationPlayer
@onready var pos2d = $Marker2D
@onready var sprite = $Marker2D/iris_rig/Sprite2D


signal current_position(pos)
signal hp_depleted
signal hp_changed(amount)
signal sp_changed(amount)
signal health_status(value)
signal interacted
signal damage_dealt(amount)
signal knock_back(_velocity, dir, xpos)
signal knock_back_stop()

func _ready():
	add_to_group("character")

func init(hp, sp):
	$hp.init(hp)
	$sp.init(sp)

func handle_input():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		emit_signal("knock_back", velocity.x, pos2d.scale.x, position.x)
	
	# interacting
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("interacted")
	
	# attacking
	if Input.is_action_just_pressed("ui_attack") and _timer >= ACTION_COOLDOWN:
		_timer = 0
		attacking = true
		emit_signal("damage_dealt", SCRATCH_DMG * dmg_multiplier * can_deal_damage)
		
	# dash
	if Input.is_action_just_pressed("ui_dash") and _timer >= ACTION_COOLDOWN:
		_timer = 0
		attacking = false
	
	if Input.is_action_pressed("ui_dash") and _timer < ACTION_COOLDOWN and is_on_floor():
		if velocity.x == 0:
			velocity.x = SPEED * 2 * pos2d.scale.x
		else:
			velocity.x *= 2
	
		emit_signal("damage_dealt", DASH_DMG * dmg_multiplier * can_deal_damage)
		emit_signal("knock_back", velocity.x, pos2d.scale.x, position.x)
		
		if Input.is_action_just_released("ui_dash") or _timer > ACTION_COOLDOWN:
			emit_signal("knock_back_stop")

	# sprite direction
	if velocity.x < 0:
		pos2d.scale.x = -1
	elif velocity.x > 0:
		pos2d.scale.x = 1

func update_animation():
	if attacking and _timer < ACTION_COOLDOWN:
		animations.play("scratch")
	elif not is_on_floor():
		if velocity.y < 0:
			animations.play("jump")
		else:
			animations.play("fall")
	elif Input.is_action_pressed("ui_dash") and _timer < ACTION_COOLDOWN:
		animations.play("dash")
	elif velocity.x:
		animations.play("walk")
	else:
		animations.play("idle")

func test_health():
	if Input.is_action_just_pressed("test_heal"):
		$hp.heal(15)
	if Input.is_action_just_pressed("test_damage"):
		$hp.take_damage(15)
	if Input.is_action_just_pressed("test_sp_heal"):
		$sp.heal(15)
	if Input.is_action_just_pressed("test_sp"):
		$sp.take_damage(15)

func set_freeze_movement(value: bool):
	freeze_movement = value
	if value == true:
		velocity.x = 0

func _physics_process(delta):
	_timer += delta
	velocity.y += gravity * delta
	
	if Save.is_small:
		can_deal_damage = 0
	else:
		can_deal_damage = 1
	
	if not freeze_movement:
		handle_input()
		emit_signal("current_position", position)
		test_health()
		
	update_animation()
	move_and_slide()

func _on_hp_health_depleted():
	set_freeze_movement(true)
	emit_signal("hp_depleted")

func _on_hp_status(value):
	emit_signal("health_status", value)

func _on_hp_health_changed(health):
	emit_signal("hp_changed", health)

func _on_sp_health_changed(health):
	emit_signal("sp_changed", health)

func _on_hp_damage_taken():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color.LIGHT_CORAL, 0.1)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)

func _on_hp_healed():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color.PALE_GREEN, 0.1)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)

func _on_enemy_attacked(amount, can_interact, pos, dir):
	if can_interact["iris"]:
		# enemy facing right, self on left
		if dir == 1 and pos.x > position.x:
			pass
		# enemy facing left, self on right
		elif dir == -1 and pos.x < position.x:
			pass
		else:
			$hp.take_damage(amount)
