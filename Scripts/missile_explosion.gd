extends Area2D

@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D

var damage: float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	collision.scale.y += 0.1
	collision.scale.x += 0.1
	pass

func _on_elimination_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
		
	if body.has_method("player_take_damage"):
		body.player_take_damage(1.0)
	pass # Replace with function body.
