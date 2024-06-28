extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -600.0
const ACTION_COOLDOWN = 0.8

var _timer = ACTION_COOLDOWN
var prev_dir = 1
var attacking = false
var can_interact = false

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animations = $Marker2D/iris_rig/Sprite2D/AnimationPlayer
@onready var pos2d = $Marker2D
@onready var audio_jump = $audio_jump
@onready var audio_scratch = $audio_scratch

signal hp_depleted
signal interacted
signal left

func handle_input():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		audio_jump.play()
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("ui_attack"):
		if _timer >= ACTION_COOLDOWN:
			_timer = 0
			audio_scratch.play()
			attacking = true
	if animations.is_playing() and animations.current_animation == "scratch":
		velocity.x = 0
		
	if Input.is_action_pressed("ui_dash"):
		if velocity.x == 0:
			velocity.x = SPEED * 2 * prev_dir
		else:
			velocity.x *= 2
			
	if Input.is_action_pressed("ui_accept") and can_interact:
		emit_signal("interacted")

	if velocity.x < 0:
		pos2d.scale.x = -1
		prev_dir = -1
	elif velocity.x > 0:
		pos2d.scale.x = 1
		prev_dir = 1

func update_animation():
	if not is_on_floor():
		if velocity.y < 0:
			animations.play("jump")
		else:
			animations.play("fall")
	elif Input.is_action_pressed("ui_dash"):
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
		
	handle_input()
	update_animation()
	test_health()
	move_and_slide()

func _on_hp_health_depleted():
	emit_signal("hp_depleted")

func _on_area_2d_area_entered(_area):
	can_interact = true

func _on_area_2d_area_exited(_area):
	can_interact = false
	emit_signal("left")
