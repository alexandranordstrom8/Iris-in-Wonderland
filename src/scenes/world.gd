extends Node2D
@onready var animation = $card_platform4/AnimationPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animation.play("slide")
