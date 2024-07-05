extends AnimatedCharacter

const ACTION_COOLDOWN = 3
var _timer = ACTION_COOLDOWN
var interacting = false

func _physics_process(_delta):
	_timer += _delta
	if _timer >= ACTION_COOLDOWN and interacting == false:
		super.change_animation("default")
	super._physics_process(_delta)

func _on_iris_interacted():
	super.change_animation("idle")
	interacting = true

func _on_iris_left_area():
	_timer = 0
	interacting = false
