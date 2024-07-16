extends Panel

signal exit_interacted

func _ready():
	visible = false

func _process(_delta):
	if self.name.contains("Exit") and visible:
		if Input.is_action_just_pressed("ui_accept"):
			emit_signal("exit_interacted")
			visible = false

func _on_area_2d_body_entered(body):
	if body.name == "iris":
		visible = true

func _on_area_2d_body_exited(body):
	if body.name == "iris":
		visible = false
