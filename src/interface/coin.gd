extends Node2D

@export var value : int = 1

signal coin_collected(value)

func _ready():
	add_to_group("coins")
	$Area2D/AnimationPlayer.play("float")

func _on_area_2d_body_entered(body):
	if body.name == "iris":
		emit_signal("coin_collected", value)
		queue_free()
