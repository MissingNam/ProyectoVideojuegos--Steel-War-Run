extends Area2D

@onready var sprite = $AnimatedSprite2D
@onready var coll = $CollisionShape2D

var speed = 400.0
var direction := Vector2.ZERO
var damage: float = 0.2

func _ready():
	sprite.play("default")
	rotation = direction.angle()
	if direction.x < 0:
		sprite.flip_v = true
	coll.shape.radius = 4.8
	
func _process(delta: float) -> void:
	scale.x += 5*delta
	scale.y += 5*delta
	coll.shape.radius += 4*delta
	global_position += direction*speed*delta
	
func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	if body.has_method("hubris_take_damage"):
		body.hubris_take_damage(damage)
		queue_free()
	if body.is_in_group("Organic") and !body.is_in_group("Player") and !body.has_node("Fire"):
		ParticlesSpawner.create_fire(body)
		
func _on_remove_timer_timeout() -> void:
	queue_free()

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	if(body.has_method("hubris_take_damage")):
		body.hubris_take_damage(damage)
		queue_free()
