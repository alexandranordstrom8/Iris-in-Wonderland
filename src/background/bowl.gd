extends StaticBody2D

var active : bool = true

signal heal
signal exited

func _ready():
	var world = get_tree().current_scene
	heal.connect(world._on_bowl_heal)
	exited.connect(world._on_bowl_exited)

func _on_area_2d_body_entered(body):
	if body.name == "iris" and active:
		emit_signal("heal")
		active = false
		$Glow.visible = false

func _on_area_2d_body_exited(body):
	if body.name == "iris":
		emit_signal("exited")
		$Timer.start()

func _on_timer_timeout():
	active = true
	$Glow.visible = true
