extends AnimatedCharacter

const ACTION_COOLDOWN = 3
var _timer = ACTION_COOLDOWN

func _physics_process(_delta):
	_timer += _delta
	if _timer >= ACTION_COOLDOWN and not can_interact:
		change_animation("default")
	super._physics_process(_delta)

func _on_iris_interacted():
	if can_interact:
		if animation_name == "default":
			Save._save.unlocked_characters.characters["Benjamin"] = true
			change_animation("idle")
			await get_tree().create_timer(0.1).timeout
		emit_signal("show_text", dialogue_key)

func _on_area_2d_body_entered(body):
	super(body)

func _on_area_2d_body_exited(body):
	_timer = 0
	super._on_area_2d_body_exited(body)
