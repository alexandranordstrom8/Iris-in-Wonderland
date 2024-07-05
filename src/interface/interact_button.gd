extends Panel

func _ready():
	visible = false

func _on_area_2d_body_entered(body):
	if body.name == "iris":
		print("body entered")
		visible = true

func _on_area_2d_body_exited(body):
	if body.name == "iris":
		print("body exited")
		visible = false

func _on_iris_interacted():
	visible = false
