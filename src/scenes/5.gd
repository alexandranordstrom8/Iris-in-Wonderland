extends World

@onready var bounce_platform = $platforms/bounce

func _ready():
	init_values()
	player.position = $markers/spawn.position

func _process(_delta):
	bounce_platform.position.x = player.position.x

func _on_bounce_area_body_entered(body):
	if body.name == "iris":
		var tween_scale = get_tree().create_tween()
		var tween_pos = get_tree().create_tween()
		var _scale = bounce_platform.scale
		
		tween_scale.tween_property(bounce_platform, "scale", Vector2(1.5, 1), 0.2)
		tween_pos.tween_property(bounce_platform, "position", Vector2(bounce_platform.position.x, bounce_platform.position.y-20), 0.2)
		
		tween_scale.tween_property(bounce_platform, "scale", _scale, 0.2)
		tween_pos.tween_property(bounce_platform, "position", Vector2(bounce_platform.position.x, bounce_platform.position.y+20), 0.2)
		
		player.velocity.y = -1400
