extends Node2D

const SPEED = 10

var target_pos : Vector2
var target_reached : bool = false
var direction : int
var offset = SPEED

@onready var walk_timer = $StartWalking
@onready var pos2d = $Marker2D
@onready var pos_ref1 = $markers/Marker2D
@onready var pos_ref2 = $markers/Marker2D2
@onready var animations = $Marker2D/Caterpillar/AnimationPlayer

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	get_dir()
	target_pos = position
	walk_timer.start()

func _process(_delta):
	if not ((direction == -1 and position.x <= target_pos.x + offset)\
	or (direction == 1 and position.x >= target_pos.x - offset)):
		animations.play("walk")
		position.x += direction * SPEED 
	else:
		animations.play("idle")

func get_dir():
	direction = pos2d.scale.x * -1

func _on_start_walking_timeout():
	get_dir()
	if direction == 1:
		target_pos = pos_ref2.position
	else:
		target_pos = pos_ref1.position
	set_process(true)
	target_reached = false

func _on_area_2d_body_entered(body):
	if body.name == "Caterpillar" and not target_reached:
		target_reached = true
		animations.play("stand")
		set_process(false)

func _on_caterpillar_standing_up():
	pos2d.scale.x *= -1

func _on_caterpillar_on_floor():
	animations.play("idle")
	walk_timer.start()
