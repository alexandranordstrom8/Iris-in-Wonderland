extends Node2D

@export var value : int = 1

signal coin_collected(value)

func _ready():
	var world = get_tree().current_scene
	coin_collected.connect(world.interface._on_coin_coin_collected)
	$Area2D/AnimationPlayer.play("float")

func _on_area_2d_body_entered(body):
	if body.name == "iris":
		emit_signal("coin_collected", value)
		queue_free()
