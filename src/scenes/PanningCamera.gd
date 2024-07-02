class_name PanningCamera
extends Camera2D

const PANNING = 800
const COOLDOWN = 2

var is_panning = false
var done = true
var timer = COOLDOWN
var target = 0
var move_speed = 10

signal finished_panning

func _process(_delta): 
	if not done:
		timer += _delta
	if is_panning:
		if position.x < target:
			position.x += move_speed
		else:
			timer = 0
			is_panning = false
	
	if not is_panning and timer > COOLDOWN: 		
		timer = COOLDOWN
		emit_signal("finished_panning")
		done = true
	
func _on_boss_level_pan_camera():	
	is_panning = true
	done = false
	target = position.x + PANNING

func _on_iris_current_position(pos):
	position = pos
