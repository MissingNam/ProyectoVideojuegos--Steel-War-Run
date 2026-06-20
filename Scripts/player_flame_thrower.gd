extends Area2D

@onready var sprite = $AnimatedSprite2D

var speed = 400.0
var direction := Vector2.ZERO
var damage: float = 0.2

func _ready():
	sprite.play("default")
	rotation = direction.angle()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale.x += 0.07
	scale.y += 0.07
	global_position += direction * speed * delta
	pass

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	if(body.has_method("hubris_take_damage")):
		body.hubris_take_damage(damage)
		queue_free()

func _on_remove_timer_timeout() -> void:
	queue_free()

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	if(body.has_method("hubris_take_damage")):
		body.hubris_take_damage(damage)
		queue_free()
