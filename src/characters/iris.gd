extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -600.0
const ACTION_COOLDOWN = 0.8

var freeze_movement = false

var _timer = ACTION_COOLDOWN
var attacking = false
var can_interact = false

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animations = $Marker2D/iris_rig/Sprite2D/AnimationPlayer
@onready var pos2d = $Marker2D
@onready var audio_jump = $audio_jump
@onready var audio_scratch = $audio_scratch

var scratch_dmg = 10
var dash_dmg = 1

signal current_position(pos)
signal hp_depleted
signal interacted
signal left_area
signal damage_dealt(amount)
signal knock_back(_velocity, dir, xpos)
signal knock_back_stop()

func handle_input():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		audio_jump.play()
		velocity.y = JUMP_VELOCITY
	
	# attacking or interacting
	if Input.is_action_just_pressed("ui_attack") and _timer >= ACTION_COOLDOWN:
		_timer = 0
		audio_scratch.play()
		attacking = true
		
		if can_interact:
			emit_signal("interacted")
			emit_signal("damage_dealt", scratch_dmg)
	
	if animations.is_playing() and animations.current_animation == "scratch":
		velocity.x = 0
		
	# dash
	if Input.is_action_just_pressed("ui_dash") and _timer >= ACTION_COOLDOWN:
		_timer = 0
		attacking = false
	
	if Input.is_action_pressed("ui_dash") and _timer < ACTION_COOLDOWN:
		if velocity.x == 0:
			velocity.x = SPEED * 2 * pos2d.scale.x
		else:
			velocity.x *= 2
		if can_interact:
			emit_signal("knock_back", velocity.x, pos2d.scale.x, position.x)
			emit_signal("damage_dealt", dash_dmg)
			
	if can_interact:
		if Input.is_action_just_released("ui_dash") or _timer > ACTION_COOLDOWN:
			emit_signal("knock_back_stop")

	# sprite direction
	if velocity.x < 0:
		pos2d.scale.x = -1
	elif velocity.x > 0:
		pos2d.scale.x = 1

func update_animation():
	if not is_on_floor():
		if velocity.y < 0:
			animations.play("jump")
		else:
			animations.play("fall")
	elif Input.is_action_pressed("ui_dash") and _timer < ACTION_COOLDOWN:
		animations.play("dash")
	elif attacking and _timer < ACTION_COOLDOWN:
		animations.play("scratch")
	elif velocity.x:
		animations.play("walk")
	else:
		animations.play("idle")

func test_health():
	if Input.is_action_just_pressed("test_heal"):
		$hp.heal(5)
	if Input.is_action_just_pressed("test_damage"):
		$hp.take_damage(5)
	if Input.is_action_just_pressed("test_sp_heal"):
		$sp.heal(5)
	if Input.is_action_just_pressed("test_sp"):
		$sp.take_damage(5)

func _physics_process(delta):
	_timer += delta
	velocity.y += gravity * delta
		
	if not freeze_movement:
		handle_input()
		emit_signal("current_position", position)
		
	update_animation()
	test_health()
	move_and_slide()

func _on_hp_health_depleted():
	emit_signal("hp_depleted")

func _on_area_2d_area_entered(_area):
	can_interact = true

func _on_area_2d_area_exited(_area):
	can_interact = false
	emit_signal("left_area")

func _on_boss_level_pan_camera(_can_target_pos):
	velocity.x = 0
	freeze_movement = true

func _on_panning_camera_finished_panning():
	freeze_movement = false

func _on_cat_attacked(dmg):
	$hp.take_damage(dmg)
