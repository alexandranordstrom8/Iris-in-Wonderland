extends Character

@onready var animations = $Marker2D/iris_rig/Sprite2D/AnimationPlayer
@onready var pos2d = $Marker2D

func handle_input():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
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
	elif velocity.x:
		animations.play("walk")
	else:
		animations.play("idle")

func _physics_process(delta):
	super._physics_process(delta)
		
	handle_input()
	update_animation()
	move_and_slide()
