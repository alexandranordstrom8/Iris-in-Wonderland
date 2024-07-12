extends World

#@onready var interface = $ui/Interface

func _ready():
	super._ready()
	$character/iris/Marker2D.scale.x = -1

func _on_exit_button_exit_interacted():
	change_scene(ScenePaths.scene_1, ScenePaths.scene_0)
