extends Node2D
@onready var animation = $platforms/card_platform4/AnimationPlayer
@onready var animation2 = $platforms/card_platform6/AnimationPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animation.play("slide")
	animation2.play("slide")
