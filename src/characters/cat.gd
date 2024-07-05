extends Enemy

@onready var animations = $Marker2D/AnimationPlayer
@onready var pos2d = $Marker2D

const OFFSET = 80

var can_interact = false
var freeze_movement = true
var target_pos: Vector2
var timer = 0

var dmg = 5

func _ready():
	$hp.change_max(500)

func update_position(delta):
	if position.x < target_pos.x - OFFSET:
		velocity.x += SPEED * delta
		pos2d.scale.x = -1
	elif position.x > target_pos.x + OFFSET:
		velocity.x -= SPEED * delta
		pos2d.scale.x = 1
	else:
		velocity.x = 0
		
func timer_actions():
	if can_interact and timer >= ACTION_COOLDOWN:
		timer = 0
		if target_pos.y > position.y:
			if pos2d.scale.x == 1 and target_pos.x - OFFSET > position.x:
				pass
			if pos2d.scale.x == -1 and target_pos.x + OFFSET < position.x:
				pass
			else:
				emit_signal("attacked", dmg)

func update_animation():
	if can_interact and timer < ACTION_COOLDOWN/2:
		animations.play("attack")
	elif velocity.x:
		animations.play("walk")
	else:
		animations.play("idle")

func _physics_process(delta):
	timer += delta
	super._process(delta)
	
	if not freeze_movement:
		update_position(delta)
	
	timer_actions()
	update_animation()
	move_and_slide()

func _on_hp_health_depleted():
	freeze_movement = true
	can_interact = false

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
	$hp.take_damage(amount)

func _on_iris_knock_back(_velocity, dir, xpos):
	if dir == 1 and xpos > position.x:
		pass
	elif dir == -1 and xpos < position.x:
		pass
	else:
		can_interact = false
		velocity.x = int(_velocity * 0.75)

func _on_iris_knock_back_stop():
	can_interact = true
	velocity.x = SPEED * pos2d.scale.x * -1
