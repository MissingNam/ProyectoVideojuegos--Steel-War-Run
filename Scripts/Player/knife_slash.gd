extends Area2D

@onready var sprite = $AnimatedSprite2D
var direction: float = 1.0
var creator
var damage = 0.5

func _ready() -> void:
	sprite.play("default")
	if direction == 0 : direction = -1
	scale.x = direction

func _process(_delta: float) -> void:
	global_position.y = creator.global_position.y 
	global_position.x = creator.global_position.x + (direction*25)

func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	if body.has_method("hubris_take_damage"):
		body.hubris_take_damage(damage)
	if body.is_in_group("Human") and !body.is_in_group("Player"):
		ParticlesSpawner.create_blood(body.global_position)
	if body.is_in_group("Cactus"):
		ParticlesSpawner.create_cactus_particles(body.global_position)
	if body.is_in_group("Rock"):
		ParticlesSpawner.create_rock_particles(body.global_position)
	
