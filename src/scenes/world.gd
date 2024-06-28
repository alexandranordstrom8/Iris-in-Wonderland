extends Node2D
@onready var music = $AudioStreamPlayer

signal interacted

func _ready():
	#pass
	music.play()

func _process(_delta):
	pass
