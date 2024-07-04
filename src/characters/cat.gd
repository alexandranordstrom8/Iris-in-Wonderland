extends Enemy

@onready var animations = $Marker2D/AnimationPlayer
@onready var pos2d = $Marker2D

const OFFSET = 75

var can_interact = false
var freeze_movement = true
var target_pos: Vector2
var timer = 0

var dmg = 5

func update_position(delta):
	if position.x < target_pos.x - OFFSET:
		velocity.x += SPEED * delta
		pos2d.scale.x = -1
	elif position.x > target_pos.x + OFFSET:
		velocity.x -= SPEED * delta
		pos2d.scale.x = 1
	else:
		velocity.x = 0
		
func play_audio():
	if can_interact and timer >= ACTION_COOLDOWN:
		timer = 0
		$audio_attack.play()
		emit_signal("attacked", dmg)

func update_animation():
	if can_interact and timer < ACTION_COOLDOWN:
		animations.play("attack")
	elif velocity.x:
		animations.play("walk")
	else:
		animations.play("idle")

func test_damage():	
	if Input.is_action_just_pressed("test_damage"):
		$hp.take_damage(5)

func _physics_process(delta):
	timer += delta
	super._process(delta)
	
	if not freeze_movement:
		update_position(delta)
	
	play_audio()
	update_animation()
	move_and_slide()

func _on_hp_health_depleted():
	pass # Replace with function body.

func _on_panning_camera_finished_panning():
	freeze_movement = false

func _on_iris_current_position(pos):
	target_pos = pos
	
func _on_area_2d_body_entered(body):
	if body.name == "iris":
		timer = ACTION_COOLDOWN
		can_interact = true
		freeze_movement = true

func _on_area_2d_body_exited(body):
	if body.name == "iris":
		can_interact = false
		freeze_movement = false

func _on_iris_damage_dealt(amount):
	#print("damage: %s" % amount)
	$hp.take_damage(amount)

func _on_iris_knock_back(_velocity, dir, xpos):
	if dir == 1 and xpos > position.x:
		pass
	elif dir == -1 and xpos < position.x:
		pass
	else:
		can_interact = false
		velocity.x = _velocity

func _on_iris_knock_back_stop():
	can_interact = true
