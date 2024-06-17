extends CharacterBody2D

@onready var animations = $Marker2D/iris_rig/body/AnimationPlayer
@onready var pos2d = $Marker2D

const SPEED = 500.0
const JUMP_VELOCITY = -600.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func handle_input():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if velocity.x < 0:
		pos2d.scale.x = -1
	elif velocity.x > 0:
		pos2d.scale.x = 1

func update_animation():
	if not is_on_floor():
		animations.play("jump")
	elif velocity.x:
		animations.play("walk")
	else:
		animations.play("idle")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	handle_input()
	update_animation()
	move_and_slide()
