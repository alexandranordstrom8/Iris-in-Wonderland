class_name Health
extends Node

@export var max_health = 100
@export var health = 0

signal health_changed(health)
signal max_health_changed(maximum)
signal health_depleted
signal not_hurt
signal hurt
signal severely_hurt

func _ready():
	health = max_health
	emit_signal("max_health_changed", max_health)
	emit_signal("health_changed", health)

func take_damage(amount):
	health -= amount
	health = max(0, health)
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("health_depleted")
	elif health < 0.3 * max_health:
		emit_signal("severely_hurt")
	elif health < 0.5 * max_health:
		emit_signal("hurt")

func heal(amount):
	health += amount
	health = min(health, max_health)
	emit_signal("health_changed", health)
	if health >= 0.5 * max_health:
		emit_signal("not_hurt")
	elif health >= 0.3 * max_health:
		emit_signal("hurt")
	
func change_max(maximum):
	max_health = maximum
	health = maximum
	emit_signal("max_health_changed", maximum)
	emit_signal("health_changed", health)
