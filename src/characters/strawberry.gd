extends Enemy

var run : bool = false
var dir = -1

@export var moving : bool = true
@export var roll_speed : int = 200

@onready var run_animation = $Marker2D/Sprite2D/AnimationPlayer
@onready var anim_sprite = $Marker2D/AnimatedSprite2D
@onready var sprite = $Marker2D/Sprite2D
@onready var pos2d = $Marker2D

func _physics_process(delta):
	super._process(delta)
	
	if dir == -1:
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
		

func _on_detection_area_body_entered(body):
	if body.get_parent().name == "character" and moving:
		run = true
		anim_sprite.visible = false
		sprite.visible = true
		if body.position.x < position.x:
			dir = 1
		else:
			dir = -1

func _on_detection_area_body_exited(body):
	if body.get_parent().name == "character" and moving:
		run = false
		anim_sprite.visible = true
		sprite.visible = false
