extends Enemy

const OFFSET = 30
const FLY_SPEED = 10

@onready var pos2d = $Marker2D

signal new_target

func _ready():
	gravity = 0
	set_target_pos(position)

func update_position():
	if position.x < target_pos.x - OFFSET:
		position.x += FLY_SPEED
		pos2d.scale.x = 1
	elif position.x > target_pos.x + OFFSET:
		position.x -= FLY_SPEED
		pos2d.scale.x = -1
	if position.y < target_pos.y - OFFSET:
		position.y += FLY_SPEED
	elif position.y > target_pos.y + OFFSET:
		position.y -= FLY_SPEED

func _physics_process(_delta):
	update_position()
	move_and_slide()

func _on_timer_timeout():
	if not chase:
		print(target_pos, position)
		print("new target")
		emit_signal("new_target")
