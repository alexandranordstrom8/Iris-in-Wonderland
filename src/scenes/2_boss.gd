extends World

var started : bool = false
var won : bool = false
var play_music : bool = false
var coin_spawn_pos : Vector2

@onready var cat_pos = $character/cat.position
@onready var enemy = $character/cat
@onready var enemy_hp_bar = $character/player/ui/CanvasLayer/VBoxContainer
@onready var camera = $character/player/DefaultCamera

func _ready():
	super()
	player.position = $markers/Marker2D.position
	$audio/ambience.play()

func _process(_delta):
	if play_music and $audio/music.volume_db < 0:
		$audio/music.volume_db += 0.1
	if started and not won:
		$buttons/ExitButton.visible = false

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
	Save._save.unlocked_characters.characters["Cat"] = true
	
func _on_cat_hp_depleted():
	won = true
	coin_spawn_pos = enemy.position
	$audio/music.stop()
	$audio/ambience.play()
	
	await get_tree().create_timer(1.5).timeout
	enemy.queue_free()
	$audio/win.play()
	enemy_hp_bar.visible = false
	var _coin = load("res://Iris-in-Wonderland/src/interface/coin.tscn").instantiate()
	$collectibles.add_child(_coin)
	_coin.position = coin_spawn_pos
	_coin.scale *= 2
	_coin.value = 50

func _on_iris_hp_depleted():
	$audio/music.stop()

func _on_cat_timer_timeout():
	if enemy.chase:
		enemy.set_target_pos(player.position)
	else:
		enemy.set_target_pos(Vector2(randi_range(250, 3000), 0))

func _on_exit_button_exit_interacted():
	if won or not started:
		change_scene(ScenePaths.scene_4)

