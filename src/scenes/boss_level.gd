extends Node2D

var started = false
var play_music = false

@onready var cat_pos = $character/cat.position
@onready var player = $character/iris
@onready var enemy = $character/cat
@onready var enemy_hp_bar = $ui/VBoxContainer

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
	enemy_hp_bar.visible = true
	enemy.set_freeze_movement(false)
	enemy.set_target_pos(player.position)
	
func _on_cat_hp_depleted():
	$audio/music.stop()
	$audio/ambience.play()
	enemy_hp_bar.visible = false

func _on_cat_timer_timeout():
	print("TIMEOUT")
	if enemy.chase:
		print("player target")
		enemy.set_target_pos(player.position)
	else:
		enemy.set_target_pos(Vector2(randi_range(250, 3000), 0))
