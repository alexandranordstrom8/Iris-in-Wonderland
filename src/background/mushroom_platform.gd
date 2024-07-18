extends StaticBody2D

@export var bounce_velocity : int
@export var bounce_active : bool

func _on_bounce_area_body_entered(body):
	if bounce_active:
		if body.get_parent().name == "character" or body.name == "iris":
			var tween = get_tree().create_tween()
			var _scale = $Sprite2D.scale
			body.velocity.y = -1 * bounce_velocity
			body.move_and_slide()
			tween.tween_property($Sprite2D, "scale", Vector2(_scale.x * 1, _scale.y * 1.1), 0.2)
			tween.tween_property($Sprite2D, "scale", Vector2(_scale.x * 1, _scale.y * 1), 0.2)
