extends Node2D

@onready var particles = $CPUParticles2D
@onready var timer = $Timer

var direccion = 0

func _ready() -> void:
	particles.direction = direccion
	particles.emitting = true
	timer.start()

func _on_timer_timeout() -> void:
	queue_free()
