extends Node2D

var started = false

signal pan_camera()

func _on_start_area_body_entered(body):
	if body.name == "iris" and not started:
		started = true
		emit_signal("pan_camera")

func _on_panning_camera_finished_panning():
	$ui/VBoxContainer.visible = true
