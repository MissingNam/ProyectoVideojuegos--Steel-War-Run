extends Area2D

class_name player_bullet

var speed = 1000.0
var direction := Vector2.ZERO
var damage: float = 1.0

func _process(delta):
	global_position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	if body.has_method("hubris_take_damage"):
		body.hubris_take_damage(damage)
		
	if body.is_in_group("Human") and !body.is_in_group("Player"):
		ParticlesSpawner.create_blood(global_position)
		queue_free()
	if body.is_in_group("Cactus"):
		ParticlesSpawner.create_cactus_particles(body.global_position)
		queue_free()
	if body.is_in_group("Bush"):
		ParticlesSpawner.create_bush_particles(body.global_position)
	if body.is_in_group("Rock"):
		ParticlesSpawner.create_rock_particles(global_position)
		queue_free()
	if body.is_in_group("Box"):
		queue_free()
