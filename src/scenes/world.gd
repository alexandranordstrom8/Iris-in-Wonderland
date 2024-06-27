extends Node2D
@onready var music = $AudioStreamPlayer
@onready var benjamin = $character/benjamin/AnimatedSprite2D

func _ready():
	#pass
	music.play()

func _process(_delta):
	#benjamin.change_animation("idle")
	pass
