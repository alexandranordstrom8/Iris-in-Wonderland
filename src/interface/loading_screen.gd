extends CanvasLayer

@export var next_scene : String

func _ready():
	ResourceLoader.load_threaded_request(next_scene)

func _process(_delta):
	if ResourceLoader.load_threaded_get_status(next_scene) == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		await get_tree().create_timer(0.5).timeout
		
		var next : PackedScene = ResourceLoader.load_threaded_get(next_scene)
		var new_node = next.instantiate()
		var current_scene = get_tree().current_scene 
		
		get_tree().get_root().add_child(new_node) 
		get_tree().current_scene = new_node 
		current_scene.queue_free() 
