extends Node2D
@onready var music = $AudioStreamPlayer
@onready var benjamin = $character/benjamin/AnimatedSprite2D

func _ready():
	#pass
	music.play()
	#benjamin.play("sleep")

func _process(_delta):
	benjamin.play("sleep")
	pass
