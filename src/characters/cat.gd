extends Enemy

@onready var animations = $Marker2D/AnimationPlayer
@onready var pos2d = $Marker2D

const OFFSET = 80

var chase: bool
var timer = 0
var dmg = 5

signal attack_animated

func _ready():
	super._ready()
	chase = true

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

func update_animation():
	if not freeze_movement:
		for entity in can_interact:
			if can_interact[entity] and not entity == self.name:
				animations.play("attack")
				return
	if velocity.x:
		animations.play("walk")
	else:
		animations.play("idle")

func _physics_process(delta):
	timer += delta
	super._process(delta)
	
	if not freeze_movement:
		update_position(delta)
		
	update_animation()
	move_and_slide()

func _on_attack_animated():
	print(can_interact)
	emit_signal("attacked", dmg, can_interact, self.name)

func _on_hp_health_depleted():
	set_freeze_movement(true)
	emit_signal("hp_depleted")

func _on_detection_area_body_entered(body):
	if body.get_parent().name == "character" and not body == self:
		print("%s, %s entered" %[self.name, body.name])
		$audio_meow.play()
		chase = true
		target_pos = body.position

func _on_detection_area_body_exited(body):
	if body.get_parent().name == "character":
		print("%s, %s exited" %[self.name, body.name])
		chase = false

func _on_hitbox_body_entered(body):
	if body.get_parent().name == "character":
		set_can_interact(body.name, true)

func _on_hitbox_body_exited(body):
	if body.get_parent().name == "character":
		set_can_interact(body.name, false)
		set_freeze_movement(false)

func _on_iris_damage_dealt(amount):
	if can_interact["iris"]:
		super._on_iris_damage_dealt(amount)

func _on_iris_knock_back(_velocity, dir, xpos):
	if can_interact["iris"]:
		# player facing right, enemy on left
		if dir == 1 and xpos > position.x:
			pass
		# player facing left, enemy on right
		elif dir == -1 and xpos < position.x:
			pass
		else:
			set_freeze_movement(true)
			velocity.x = int(_velocity * 0.75)

func _on_iris_knock_back_stop():
	set_freeze_movement(false)
	velocity.x = 0
