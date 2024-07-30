extends World

@export var empty : bool = false

func _ready():
	super()
	empty = Save.table_empty
	if empty:
		var strawberries = get_tree().get_nodes_in_group("enemy")
		for s in strawberries:
			s.queue_free()

func _on_interact_button_exit_interacted():
	change_scene(ScenePaths.scene_3, false)
