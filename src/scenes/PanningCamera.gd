extends Camera2D

const DOWN_OFFSET = 270

@onready var timer = $Timer

var is_panning = false
var free_movement = false
var look_down_possible = true
var target = 0
var look_down_target = Vector2(0, 0)
var move_speed = 10

signal timer_started
signal finished_panning

func handle_input():
	if look_down_possible:
		if Input.is_action_just_pressed("ui_down"):
			print("pressed")
			look_down_target = position.y + DOWN_OFFSET
			free_movement = true
		if Input.is_action_pressed("ui_down") and position.y <= look_down_target:
			position.y += DOWN_OFFSET
		if Input.is_action_just_released("ui_down"):
			print("released")
			position.y -= DOWN_OFFSET
			free_movement = false

func _process(_delta): 
	if is_panning:
		if position.y < target.y:
			position.y += move_speed
		elif position.y > target.y:
			position.y -= move_speed
		if position.x < target.x:
			position.x += move_speed
		elif position.x > target.x + move_speed:
			position.x -= move_speed
		else:
			is_panning = false
			free_movement = false
			timer.start()
			emit_signal("timer_started")
	else:
		handle_input()
	
func _on_boss_level_pan_camera(target_pos):
	is_panning = true
	free_movement = true
	target = target_pos

func _on_iris_current_position(pos):
	if not free_movement:
		position = pos

func _on_timer_timeout():
	emit_signal("finished_panning")

func _on_stop_look_down_body_entered(body):
	if body.name == "iris":
		print("look down not possible")
		look_down_possible = false

func _on_stop_look_down_body_exited(body):
	if body.name == "iris":
		print("look down possible")
		look_down_possible = true
