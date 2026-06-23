extends Node2D

func _ready() -> void:
	$Particles.emitting = true

func _on_delete_timer_timeout() -> void:
	queue_free()
