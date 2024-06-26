extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -600.0

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animations = $Marker2D/iris_rig/Sprite2D/AnimationPlayer
@onready var pos2d = $Marker2D
@onready var audio_jump = $audio_jump

func handle_input():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		audio_jump.play()
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_pressed("ui_attack"):
		velocity.x = 0
	elif Input.is_action_pressed("ui_dash"):
		velocity.x *= 2

	if velocity.x < 0:
		pos2d.scale.x = -1
	elif velocity.x > 0:
		pos2d.scale.x = 1

func update_animation():
	if Input.is_action_pressed("ui_attack"):
		animations.play("scratch")
	elif not is_on_floor():
		if velocity.y < 0:
			animations.play("jump")
		else:
			animations.play("fall")
	elif Input.is_action_pressed("ui_dash"):
		animations.play("dash")
	elif velocity.x:
		animations.play("walk")
	else:
		animations.play("idle")

func _physics_process(delta):
	velocity.y += gravity * delta
		
	handle_input()
	update_animation()
	move_and_slide()
