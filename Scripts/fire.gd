extends Node2D

func _ready() -> void:
	$DeleteTimer.start()
	$HitCooldown.start()

func _on_delete_timer_timeout() -> void:
	queue_free()

func _on_hit_cooldown_timeout() -> void:
	if get_parent().has_method("take_damage"):
		get_parent().take_damage(1)
