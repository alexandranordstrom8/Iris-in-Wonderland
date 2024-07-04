class_name PanningCamera
extends Camera2D

const COOLDOWN = 2

var is_panning = false
var done = true
var timer = COOLDOWN
var target = 0
var move_speed = 10

signal timer_started
signal finished_panning

func _process(_delta): 
	if not done:
		timer += _delta
	if is_panning:
		if position.y < target.y:
			position.y += move_speed
		elif position.y > target.y:
			position.y -= move_speed
		if position.x < target.x:
			position.x += move_speed
		else:
			timer = 0
			is_panning = false
			emit_signal("timer_started")
	
	if not is_panning and timer > COOLDOWN: 		
		timer = COOLDOWN
		emit_signal("finished_panning")
		done = true
	
func _on_boss_level_pan_camera(target_pos):	
	is_panning = true
	done = false
	target = target_pos
	print(target)

func _on_iris_current_position(pos):
	position = pos
