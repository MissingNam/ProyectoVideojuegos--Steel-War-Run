extends Area2D

@onready var sprite = $AnimatedSprite2D

var speed = 1000.0
var direction := Vector2.ZERO
var damage: float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("default")


func _process(delta):
	global_position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player_take_damage"):
		body.player_take_damage(damage)
		queue_free()
	if body.is_in_group("Human") and !body.is_in_group("Enemies"):
		ParticlesSpawner.create_blood(global_position)
		queue_free()
	if body.is_in_group("Cactus"):
		ParticlesSpawner.create_cactus_particles(body.global_position)
		queue_free()
	if body.is_in_group("Rock"):
		ParticlesSpawner.create_rock_particles(global_position)
		queue_free()
