extends ParallaxBackground
@onready var animation1 = $ParallaxLayer/Sprite2D/AnimationPlayer
@onready var animation2 = $ParallaxLayer/Sprite2D2/AnimationPlayer
@onready var animation3 = $ParallaxLayer/Sprite2D3/AnimationPlayer
@onready var animation4 = $ParallaxLayer/Sprite2D4/AnimationPlayer

func _process(delta):
	scroll_base_offset -= Vector2(100, 100) * delta
	animation1.play("1")
	animation2.play("1")
	animation3.play("1")
	animation4.play("1")
