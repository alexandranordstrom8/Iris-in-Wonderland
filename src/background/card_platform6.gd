extends Enemy

const OFFSET = 0

var attack_timer = ACTION_COOLDOWN
var dead : bool = false
var prev_health = 100
var iris_hitbox2 = false

signal health_changed(amount)

func _ready():
	super()
	add_to_group("card")
	gravity = 0
	var world = get_tree().current_scene
	target_pos = world.player.position
	health_changed.connect(world._on_card_health_changed)

func update_position(delta):
	if position.x < target_pos.x - OFFSET:
		velocity.x += SPEED * delta
	elif position.x > target_pos.x + OFFSET:
		velocity.x -= SPEED * delta
	if position.y < target_pos.y - OFFSET:
		velocity.y += SPEED * delta
	elif position.y > target_pos.y + OFFSET:
		velocity.y -= SPEED * delta

func _physics_process(delta):
	attack_timer += delta
	
	if not dead:
		for entity in can_interact:
			if can_interact[entity] and not entity == self.name and attack_timer >= ACTION_COOLDOWN:
				attack_timer = 0
				emit_signal("attacked", damage, can_interact, position, scale.x)
				return
		update_position(delta)
	
	move_and_slide()

func _on_fragile_area_body_entered(body):
	if body in get_tree().get_nodes_in_group("character"):
		hp.take_damage(10)

func _on_detection_area_body_exited(body):
	if body.is_in_group("character") and not body == self:
		detected[body.name] = false
		if detected_empty():
			emit_signal("get_position", "iris", self.name)

func _on_iris_damage_dealt(amount):
	super(amount)
	if iris_hitbox2:
		hp.take_damage(amount)

func _on_hp_damage_taken():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.DIM_GRAY, 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)

func _on_hp_health_depleted():
	dead = true
	hp.damage_taken.disconnect(_on_hp_damage_taken)
	hp.health_depleted.disconnect(_on_hp_health_depleted)
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.DIM_GRAY, 0.5)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
	
	await get_tree().create_timer(1).timeout
	queue_free()

func _on_random_pos_timeout():
	if detected_empty():
		target_pos = get_tree().current_scene.player.position

func _on_hp_health_changed(health):
	emit_signal("health_changed", prev_health - health)
	prev_health = health

func _on_hitbox_2_body_entered(body):
	if body.name == "iris":
		iris_hitbox2 = true

func _on_hitbox_2_body_exited(body):
	if body.name == "iris":
		iris_hitbox2 = false
