extends Node2D

@export var item_name : String
@export var quantity : int = 1

signal itemized(item_name, quantity)

func _ready():
	var world = get_tree().current_scene
	itemized.connect(world._on_item_itemized)
	$PickUpLabel.visible = false

func _process(_delta):
	if $PickUpLabel.visible and Input.is_action_just_pressed("ui_accept"):
		emit_signal("itemized", item_name, quantity)
		queue_free()

func _on_area_2d_body_entered(body):
	if body.name == "iris":
		$PickUpLabel.visible = true

func _on_area_2d_body_exited(body):
	if body.name == "iris":
		$PickUpLabel.visible = false
