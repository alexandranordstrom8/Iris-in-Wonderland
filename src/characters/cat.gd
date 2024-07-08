extends Enemy

@onready var animations = $Marker2D/AnimationPlayer
@onready var pos2d = $Marker2D

const OFFSET = 80

var chase: bool
var timer = 0
var dmg = 5

func _ready():
	set_freeze_movement(true)
	chase = true
	set_can_interact(false)

func update_position(delta):
	if chase:
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
		if target_pos.y >= position.y:
			# enemy facing left, player on right
			if pos2d.scale.x == 1 and target_pos.x > position.x:
				pass
			# enemy facing right, player on left
			if pos2d.scale.x == -1 and target_pos.x < position.x:
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
	set_freeze_movement(true)
	set_can_interact(false)
	emit_signal("hp_depleted")

func _on_detection_area_body_entered(body):
	if body.get_parent().name == "character":
		$audio_meow.play()
		chase = true
		target_pos = body.position

func _on_detection_area_body_exited(body):
	if body.get_parent().name == "character":
		chase = false

func _on_hitbox_body_entered(body):
	if body.name == "iris":
		set_can_interact(true)

func _on_hitbox_body_exited(body):
	if body.name == "iris":
		set_can_interact(false)
		set_freeze_movement(false)

func _on_iris_damage_dealt(amount):
	if can_interact:
		super._on_iris_damage_dealt(amount)

func _on_iris_knock_back(_velocity, dir, xpos):
	if can_interact:
		# player facing right, enemy on left
		if dir == 1 and xpos > position.x:
			pass
		# player facing left, enemy on right
		elif dir == -1 and xpos < position.x:
			pass
		else:
			#set_freeze_movement(true)
			velocity.x = int(_velocity * 0.75)

func _on_iris_knock_back_stop():
	set_freeze_movement(false)
	velocity.x = 0



