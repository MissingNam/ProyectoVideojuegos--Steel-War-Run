extends Node2D

@onready var blood = $Blood
@onready var timer = $Timer

func _ready() -> void:
	blood.emitting = true
	timer.start()

func _on_timer_timeout() -> void:
	queue_free()
