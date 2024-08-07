extends Enemy

var run : bool = false
var dir = -1

@export var moving : bool = true
@export var roll_speed : int = 200
@export var can_pick_up : bool = true

@onready var run_animation = $Marker2D/Sprite2D/AnimationPlayer
@onready var anim_sprite = $Marker2D/AnimatedSprite2D
@onready var sprite = $Marker2D/Sprite2D
@onready var pos2d = $Marker2D
@onready var label = $Hitbox/Button

signal itemized(item_name, quantity)

func _ready():
	super()
	var world = get_tree().current_scene
	itemized.connect(world._on_item_itemized)
	label.visible = false

func update_position(delta):
	if dir < 0:
		pos2d.scale.x = 1
	else:
		pos2d.scale.x = -1
	
	if velocity.x:
		run_animation.play("roll")
		move_and_slide()
	
	if run:
		velocity.x += roll_speed * dir * delta
	else:
		velocity.x = 0
		anim_sprite.play("default")

func _physics_process(delta):
	super._process(delta)
	update_position(delta)
	
	if Save.item_list["Strawberry"][0] >= Save.item_max:
		can_pick_up = false
	else: 
		can_pick_up = true
	
	if label.visible and Input.is_action_just_pressed("ui_take_item"):
		Save._save.unlocked_characters.characters["Strawberry"] = true
		emit_signal("itemized", "Strawberry", 1)
		queue_free()

func _on_health_health_depleted():
	emit_signal("attacked", damage, can_interact, position, dir)
	queue_free()

func _on_hp_damage_taken():
	var tween = get_tree().create_tween()
	tween.tween_property(pos2d, "modulate", Color.DARK_RED, 0.1)
	tween.tween_property(pos2d, "modulate", Color.WHITE, 0.1)
	
func _on_iris_damage_dealt(amount):
	super(amount)

func _on_enemy_attacked(amount, _can_interact, _position, _dir):
	super(amount, _can_interact, _position, _dir)

func _on_hitbox_body_entered(body):
	super(body)
	if body.name == "iris" and can_pick_up:
		label.visible = true

func _on_hitbox_body_exited(body):
	super(body)
	if body.name == "iris" and can_pick_up:
		label.visible = false

func _on_detection_area_body_entered(body):
	if body.is_in_group("character") and moving:
		run = true
		anim_sprite.visible = false
		sprite.visible = true
		if abs(dir) > 1:
			pass
		else:
			if body.position.x < position.x:
				dir = 1
			else:
				dir = -1

func _on_detection_area_body_exited(body):
	if body.is_in_group("character") and moving:
		run = false
		anim_sprite.visible = true
		sprite.visible = false
