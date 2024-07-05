class_name Health
extends Node

signal health_changed(health)
signal max_health_changed(maximum)
signal health_depleted

var max_health = 100
@export var health = 0

func _ready():
	health = max_health
	emit_signal("health_changed", health)

func take_damage(amount):
	health -= amount
	health = max(0, health)
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("health_depleted")

func heal(amount):
	health += amount
	health = min(health, max_health)
	emit_signal("health_changed", health)
	
func change_max(maximum):
	max_health = maximum
	health = maximum
	emit_signal("max_health_changed", maximum)
	emit_signal("health_changed", health)
