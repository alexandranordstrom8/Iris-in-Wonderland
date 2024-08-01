extends Camera2D

const DOWN_OFFSET = 270
const DEFAULT_SPEED = 10

@onready var timer = $Timer

var is_panning = false
var free_movement = false
var _stay_free : bool
var look_down_possible = true
var target = Vector2(0, 0)
var look_down_target = 0
var move_speed = DEFAULT_SPEED

signal timer_started
signal finished_panning

func handle_input():
	if Input.is_action_just_pressed("ui_down"):
		free_movement = true
		look_down_target = position.y + DOWN_OFFSET
	if Input.is_action_pressed("ui_down") and position.y <= look_down_target:
		position.y += DOWN_OFFSET
	if Input.is_action_just_released("ui_down"):
		position.y -= DOWN_OFFSET
		free_movement = false

func _process(_delta): 
	if is_panning:
		var y_changed = false
		if position.y < target.y:
			position.y += move_speed
			y_changed = true
		elif position.y > target.y + move_speed:
			position.y -= move_speed
			y_changed = true
		if position.x < target.x:
			position.x += move_speed
		elif position.x > target.x + move_speed:
			position.x -= move_speed
		elif not y_changed:
			is_panning = false
			move_speed = DEFAULT_SPEED
			timer.start()
			emit_signal("timer_started")
	elif look_down_possible:
		handle_input()
	
func set_panning_target(target_pos, stay_free = false):
	is_panning = true
	free_movement = true
	target = target_pos
	_stay_free = stay_free

func _on_iris_current_position(pos):
	if not free_movement:
		position = pos

func _on_timer_timeout():
	if not _stay_free:
		free_movement = false
	emit_signal("finished_panning")

func _on_stop_look_down_body_entered(body):
	if body.name == "iris":
		look_down_possible = false

func _on_stop_look_down_body_exited(body):
	if body.name == "iris":
		look_down_possible = true
