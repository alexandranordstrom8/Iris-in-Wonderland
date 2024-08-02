extends Enemy

const OFFSET = 30

var attack_timer = ACTION_COOLDOWN
var dead : bool = false

@onready var pos2d = $Marker2D

signal new_target(_self)

func _ready():
	super()
	gravity = 0
	set_target_pos(position)
	new_target.connect(get_tree().current_scene._on_bee_new_target)

func update_position(delta):
	if position.x < target_pos.x - OFFSET:
		velocity.x += SPEED * delta
		pos2d.scale.x = 1
	elif position.x > target_pos.x + OFFSET:
		velocity.x -= SPEED * delta 
		pos2d.scale.x = -1
	if position.y < target_pos.y - 5 * OFFSET:
		velocity.y += SPEED * delta
	elif position.y > target_pos.y + OFFSET:
		velocity.y -= SPEED * delta

func _physics_process(delta):
	attack_timer += delta
	
	if not dead:
		for entity in can_interact:
			if can_interact[entity] and not entity == self.name and attack_timer >= ACTION_COOLDOWN:
				attack_timer = 0
				emit_signal("attacked", damage, can_interact, position, pos2d.scale.x)
				return
		update_position(delta)
	
	move_and_slide()

func _on_health_health_depleted():
	dead = true
	hp.damage_taken.disconnect(_on_hp_damage_taken)
	hp.health_depleted.disconnect(_on_health_health_depleted)
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.BLACK, 0.8)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
	
	Save._save.unlocked_characters.characters["Bee"] = true
	await get_tree().create_timer(1).timeout
	queue_free()

func _on_timer_timeout():
	if not chase:
		emit_signal("new_target", self)
