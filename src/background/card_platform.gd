extends StaticBody2D

@export var bounce_velocity : int

@onready var sprite = $spring

func _on_bounce_area_body_entered(body):
	if body.get_parent().name == "character" or body.name == "iris":
		var _scale = sprite.scale
		var _pos = sprite.position
		var tween_scale = get_tree().create_tween()
		var tween_pos = get_tree().create_tween()
		
		tween_scale.tween_property(sprite, "scale", Vector2(_scale.x * 1.2, _scale.y), 0.2)
		tween_pos.tween_property(sprite, "position", Vector2(_pos.x, _pos.y - 100), 0.2).set_trans(Tween.TRANS_BOUNCE)
		
		tween_scale.tween_property(sprite, "scale", _scale, 0.2)
		tween_pos.tween_property(sprite, "position", Vector2(_pos.x, _pos.y), 0.2)
		
		body.velocity.y = -1 * bounce_velocity
