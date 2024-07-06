extends AnimatedCharacter

const ACTION_COOLDOWN = 3
var _timer = ACTION_COOLDOWN

func _physics_process(_delta):
	_timer += _delta
	if _timer >= ACTION_COOLDOWN and not can_interact:
		super.change_animation("default")
	super._physics_process(_delta)

func _on_iris_interacted():
	if can_interact:
		super.change_animation("idle")

func _on_area_2d_body_entered(body):
	super._on_area_2d_body_entered(body)

func _on_area_2d_body_exited(body):
	_timer = 0
	super._on_area_2d_body_exited(body)
