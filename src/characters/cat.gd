extends Enemy

@onready var animations = $Marker2D/AnimationPlayer
@onready var pos2d = $Marker2D
@onready var timer = $Timer

const OFFSET = 70

var chase: bool
var dmg = 5
var dead = false
var detected = {} # node_name : [node_body, true/false]

signal attack_animated

func _ready():
	set_freeze_movement(true)
	chase = true

func detected_empty():
	for entity in detected:
		if detected[entity][1]:
			target_pos = detected[entity][0].position
			return false
	return true

func update_position(delta):
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
	if dead:
		position.y += int(JUMP_VELOCITY * delta)
		position.x += int(SPEED * delta * pos2d.scale.x * -1)
		animations.play("jump")
	else:
		super._process(delta)
		
		if not freeze_movement:
			update_position(delta)
		
		update_animation()

func _on_attack_animated():
	emit_signal("attacked", dmg, can_interact, position, (pos2d.scale.x * -1))

func _on_hp_health_depleted():
	set_freeze_movement(true)
	dead = true
	$audio_meow2.play()
	emit_signal("hp_depleted")

func _on_detection_area_body_entered(body):
	if body.get_parent().name == "character" and not body == self:
		$audio_meow.play()
		chase = true
		target_pos = body.position
		detected[body.name] = [body, true]

func _on_detection_area_body_exited(body):
	if body.get_parent().name == "character" and not body == self:
		detected[body.name] = [body, false]
		
		if detected_empty():
			chase = false

func _on_hitbox_body_entered(body):
	if body.get_parent().name == "character" and not body == self:
		set_can_interact(body.name, true)

func _on_hitbox_body_exited(body):
	if body.get_parent().name == "character" and not body == self:
		set_can_interact(body.name, false)
		set_freeze_movement(false)
		if body.name == "iris":
			timer.start()

func _on_iris_damage_dealt(amount):
	super(amount)

func _on_iris_knock_back(_velocity, dir, xpos):
	super(_velocity, dir, xpos)

func _on_iris_knock_back_stop():
	super()
