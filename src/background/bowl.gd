extends StaticBody2D

@export var heal_amount : int = 10
var active : bool = true

signal heal(amount)

func _ready():
	var world = get_tree().current_scene
	heal.connect(world._on_bowl_heal)

func _on_area_2d_body_entered(body):
	if body.name == "iris" and active:
		emit_signal("heal", heal_amount)
		$Glow.visible = false

func _on_area_2d_body_exited(body):
	if body.name == "iris" and active:
		active = false
		$Timer.start()

func _on_timer_timeout():
	active = true
	$Glow.visible = true
