extends World

const card_path = "res://Iris-in-Wonderland/src/background/card_platform6.tscn"

@onready var bounce_platform = $platforms/bounce
@onready var god_sprite = $ParallaxBackground/ParallaxLayer/God
@onready var god_anim = $ParallaxBackground/ParallaxLayer/God/Sprite2D/AnimationPlayer
@onready var boss_bar = $character/player/ui/VBoxContainer
@onready var door = $platforms/card_platform1/door
@onready var card_timer = $CardTimer

var boss_health = 500
var started = false
var won = false
var at_exit = false
var at_door = false
var play_music = false

signal boss_health_changed
signal boss_max_health_changed

func _ready():
	init_values()
	boss_bar.visible = false
	door.visible = false
	player.position = $markers/spawn.position
	
	god_anim.animation_finished.connect(_on_god_anim_finished)
	
	emit_signal("boss_max_health_changed", boss_health)

func _process(_delta):
	bounce_platform.position.x = player.position.x
	
	if play_music and $audio/music.volume_db < 0:
		$audio/music.volume_db += 0.1
	
	if at_exit and Input.is_action_just_pressed("ui_accept"):
		change_scene(ScenePaths.scene_1)
	
	if at_door and Input.is_action_just_pressed("ui_accept"):
		door.get_node("closed").visible = false
		door.get_node("open").visible = true
		await get_tree().create_timer(0.5).timeout
		change_scene(ScenePaths.end_scene)

func _on_bounce_area_body_entered(body):
	if body.name == "iris":
		var tween_scale = get_tree().create_tween()
		var tween_pos = get_tree().create_tween()
		var _scale = bounce_platform.scale
		
		tween_scale.tween_property(bounce_platform, "scale", Vector2(1.5, 1), 0.2)
		tween_pos.tween_property(bounce_platform, "position", Vector2(bounce_platform.position.x, bounce_platform.position.y-20), 0.2)
		
		tween_scale.tween_property(bounce_platform, "scale", _scale, 0.2)
		tween_pos.tween_property(bounce_platform, "position", Vector2(bounce_platform.position.x, bounce_platform.position.y+20), 0.2)
		
		player.velocity.y = -1400

func _on_card_health_changed(amount):
	boss_health -= amount
	emit_signal("boss_health_changed", boss_health)
	if boss_health <= 0:
		boss_hp_depleted()

func free_cards():
	var cards = get_tree().get_nodes_in_group("card")
	for c in cards:
		c.health_changed.disconnect(_on_card_health_changed)
		c.hp.take_damage(100)
	await get_tree().create_timer(0.8).timeout

func boss_hp_depleted():
	won = true
	$audio/music.stop()
	await free_cards()
	interface.visible = false
	$DialogueWindow2.get_text("God")
	door.visible = true

func _on_dialogue_finished():
	super()
	if not started:
		started = true
		boss_bar.visible = true
		add_card($markers/card_spawn.position)
		card_timer.start()
		play_music = true
		$audio/music.play()
	if won:
		var tween = get_tree().create_tween()
		tween.tween_property(god_sprite, "modulate", Color.TRANSPARENT, 0.5)
		$audio/win.play()
		boss_bar.hide()
		$character/player/DefaultCamera.set_panning_target($markers/door.position)

func _on_convo_1_body_entered(body):
	if body.name == "iris":
		interface.visible = false
		$DialogueWindow.get_text("God")

func _on_exit_body_entered(body):
	if body.name == "iris" and not started:
		$markers/Exit/Label.visible = true
		at_exit = true

func _on_exit_body_exited(body):
	if body.name == "iris":
		$markers/Exit/Label.visible = false
		at_exit = false

func _on_door_area_body_entered(body):
	if body.name == "iris" and won:
		at_door = true
		$platforms/card_platform1/door/Label.visible = true

func _on_door_area_body_exited(body):
	if body.name == "iris" and won:
		at_door = false
		$platforms/card_platform1/door/Label.visible = false

func add_card(pos = Vector2(0, 0)):
	var _card = preload(card_path).instantiate()
	$character.add_child(_card)
	_card.position = pos

func _on_god_anim_finished(anim_name):
	if anim_name == "blink":
		god_anim.play("default")

func _on_card_timer_timeout():
	if started and not won:
		add_card()
		god_anim.play("blink")
