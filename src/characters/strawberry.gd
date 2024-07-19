extends Enemy

var run : bool = false
var dir = -1

@export var moving : bool = true
@export var roll_speed : int = 200

@onready var run_animation = $Marker2D/Sprite2D/AnimationPlayer
@onready var anim_sprite = $Marker2D/AnimatedSprite2D
@onready var _sprite = $Marker2D/Sprite2D
@onready var pos2d = $Marker2D
@onready var label = $Hitbox/Panel

signal itemized

func _ready():
	label.visible = false

func update_position(delta):
	if dir == -1:
		pos2d.scale.x = 1
	else:
		pos2d.scale.x = -1
	
	if velocity.x:
		run_animation.play("roll")
		sprite = $Marker2D/AnimatedSprite2D
		move_and_slide()
	
	if run:
		velocity.x += roll_speed * dir * delta
	else:
		velocity.x = 0
		sprite = $Marker2D/Sprite2D
		anim_sprite.play("default")

func _physics_process(delta):
	super._process(delta)
	update_position(delta)
	
	if label.visible and Input.is_action_just_pressed("ui_take_item"):
		emit_signal("itemized")

func _on_hitbox_body_entered(body):
	super(body)
	if body.name == "iris":
		label.visible = true

func _on_hitbox_body_exited(body):
	super(body)
	if body.name == "iris":
		label.visible = false

func _on_detection_area_body_entered(body):
	if body.get_parent().name == "character" and moving:
		run = true
		anim_sprite.visible = false
		_sprite.visible = true
		if body.position.x < position.x:
			dir = 1
		else:
			dir = -1

func _on_detection_area_body_exited(body):
	if body.get_parent().name == "character" and moving:
		run = false
		anim_sprite.visible = true
		_sprite.visible = false
