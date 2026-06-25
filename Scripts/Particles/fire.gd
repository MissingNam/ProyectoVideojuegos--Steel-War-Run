extends Node2D

func _ready() -> void:
	$DeleteTimer.start()
	$HitCooldown.start()
	if(ClimeManager.is_raining()):
		queue_free()

func _on_delete_timer_timeout() -> void:
	queue_free()

func _on_hit_cooldown_timeout() -> void:
	if get_parent().has_method("take_damage"):
		get_parent().take_damage(0.5 * (1+GlobalGamePlayVariables.flamethrowerFirerateMultiplier))
	if get_parent().has_method("player_take_damage") and get_parent().is_in_group("Player"):
		get_parent().player_take_damage(1)
		queue_free()

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Organic") and !body.has_node("Fire"):
		ParticlesSpawner.create_fire(body)
