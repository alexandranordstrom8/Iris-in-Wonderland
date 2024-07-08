extends Node2D

var started = false
var play_music = false

@onready var cat_pos = $character/cat.position
@onready var player = $character/iris
@onready var enemy = $character/cat

signal pan_camera(target_pos)

func _ready():
	$audio/ambience.play()

func _process(_delta):
	if play_music and $audio/music.volume_db < 0:
		$audio/music.volume_db += 0.1

func _on_start_area_body_entered(body):
	if body.name == "iris" and not started:
		started = true
		player.set_freeze_movement(true)
		emit_signal("pan_camera", cat_pos)

func _on_panning_camera_timer_started():
	$audio/meow.play()
	$audio/ambience.stop()
	$audio/music.play()
	play_music = true

func _on_panning_camera_finished_panning():
	$ui/VBoxContainer.visible = true
	enemy.set_freeze_movement(false)
	enemy.set_target_pos(player.position)
	
func _on_cat_hp_depleted():
	$audio/music.stop()
	$audio/ambience.play()
