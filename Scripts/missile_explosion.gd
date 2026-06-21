extends Area2D

@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D

var damage: float = 50

func _ready() -> void:
	sprite.play("default")

func _process(delta: float) -> void:
	collision.scale.x += 0.075
	collision.scale.y += 0.075
	damage = damage/1.1

func _on_elimination_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
		
	if body.has_method("player_take_damage"):
		body.player_take_damage(damage)
		
	if body.is_in_group("Human"):
		ParticlesSpawner.create_blood(body.global_position)
		ParticlesSpawner.create_blood(body.global_position)
		ParticlesSpawner.create_blood(body.global_position)
	if body.is_in_group("Organic"):
		ParticlesSpawner.create_fire(body)
	if body.is_in_group("Cactus"):
		ParticlesSpawner.create_cactus_particles(body.global_position)
		ParticlesSpawner.create_cactus_particles(body.global_position)
		ParticlesSpawner.create_cactus_particles(body.global_position)
	if body.is_in_group("Rock"):
		ParticlesSpawner.create_rock_particles(body.global_position)
		ParticlesSpawner.create_rock_particles(body.global_position)
		ParticlesSpawner.create_rock_particles(body.global_position)
