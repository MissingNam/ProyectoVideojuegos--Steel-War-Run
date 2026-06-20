extends Node2D

func _ready() -> void:
	$DeleteTimer.start()
	$Particles.emitting = true

func _on_delete_timer_timeout() -> void:
	queue_free()
