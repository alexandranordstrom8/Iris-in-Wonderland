extends World

var started : bool = false
var won : bool = false
var play_music : bool = false

@onready var cat_pos = $character/cat.position
@onready var enemy = $character/cat
@onready var enemy_hp_bar = $ui/VBoxContainer
@onready var camera = $camera/PanningCamera

func _ready():
	super._ready()
	player.position = $markers/Marker2D.position
	$audio/ambience.play()

func _process(_delta):
	if play_music and $audio/music.volume_db < 0:
		$audio/music.volume_db += 0.1

func _on_start_area_body_entered(body):
	if body.name == "iris" and not started:
		started = true
		player.set_freeze_movement(true)
		camera.set_panning_target(cat_pos)

func _on_panning_camera_timer_started():
	$audio/meow.play()
	$audio/ambience.stop()
	$audio/music.play()
	play_music = true

func _on_panning_camera_finished_panning():
	enemy_hp_bar.visible = true
	enemy.set_freeze_movement(false)
	player.set_freeze_movement(false)
	enemy.set_target_pos(player.position)
	
func _on_cat_hp_depleted():
	won = true
	$audio/music.stop()
	$audio/ambience.play()

func _on_iris_hp_depleted():
	$audio/music.stop()

func _on_cat_timer_timeout():
	if enemy.dead:
		enemy.queue_free()
		$audio/win.play()
		enemy_hp_bar.visible = false
	elif enemy.chase:
		enemy.set_target_pos(player.position)
	else:
		enemy.set_target_pos(Vector2(randi_range(250, 3000), 0))

func _on_exit_button_exit_interacted():
	if won or not started:
		change_scene(ScenePaths.scene_4)

func _on_bee_new_target():
	$character/Bee.set_target_pos(Vector2(randi_range(250, 3000), randi_range(100, 500)))

func _on_enemy_get_position(target_name, enemy_name):
	var target = $character.get_node(String(target_name))
	var _enemy = $character.get_node(String(enemy_name))
	_enemy.set_target_pos(target.position)
