extends Node2D

signal coin_collected

func _ready():
	$Area2D/AnimationPlayer.play("float")

func _on_area_2d_body_entered(body):
	if body.name == "iris":
		emit_signal("coin_collected")
		queue_free()
