extends Area2D

@onready var sprite = $AnimatedSprite2D
@onready var coll = $CollisionShape2D

var speed = 400.0
var direction := Vector2.ZERO
var damage = 1.0
var colorFlag : bool = true

func _ready():
	sprite.play("default")
	rotation = direction.angle()
	coll.shape.radius = 4.8

func _process(delta: float) -> void:
	scale.x += 5*delta
	scale.y += 5*delta
	coll.shape.radius += 4*delta
	global_position += direction*speed*delta

func _on_body_entered(body):
	if body.has_method("player_take_damage"):
		body.player_take_damage(damage)
	if body.is_in_group("Player") and !body.has_node("Fire"):
		ParticlesSpawner.create_fire(body)

func _on_remove_timer_timeout() -> void:
	queue_free()

func _on_switch_color_timer_timeout() -> void:
	if(colorFlag):
		sprite.modulate = Color.RED
		colorFlag = false
	else:
		sprite.modulate = Color.WHITE
		colorFlag = true
