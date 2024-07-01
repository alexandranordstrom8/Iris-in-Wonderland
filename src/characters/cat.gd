extends Enemy

@onready var animations = $Marker2D/Sprite2D/AnimationPlayer
@onready var pos2d = $Marker2D

var prev_dir = 1

func update_animation():
	animations.play("idle")
	
	#if Input.is_action_just_pressed("test_damage"):
	#	pos2d.scale.x *= -1

func _physics_process(delta):
	super._process(delta)
	update_animation()
	move_and_slide()
