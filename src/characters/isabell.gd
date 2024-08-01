extends AnimatedCharacter

var in_hitbox : bool = false

signal special_dialogue(dialogue_key)

func _process(_delta):
	if in_hitbox and Input.is_action_just_pressed("ui_attack"):
		emit_signal("special_dialogue", dialogue_key)
		set_process(false)

func _on_iris_interacted():
	if can_interact:
		Save._save.unlocked_characters.characters["Isabell"] = true
		emit_signal("show_text", dialogue_key)

func _on_hitbox_body_entered(body):
	if body.name == "iris":
		in_hitbox = true
		set_process(true)

func _on_hitbox_body_exited(body):
	if body.name == "iris":
		in_hitbox = false
