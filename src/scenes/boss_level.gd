extends Node2D

var started = false

@onready var cat_pos = $character/cat_pos.position

signal pan_camera(target_pos)

func _on_start_area_body_entered(body):
	if body.name == "iris" and not started:
		started = true
		emit_signal("pan_camera", cat_pos)

func _on_panning_camera_finished_panning():
	$ui/VBoxContainer.visible = true
