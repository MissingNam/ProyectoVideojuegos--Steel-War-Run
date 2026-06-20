extends Area2D

@onready var sprite = $AnimatedSprite2D
var direction: float = 1.0
var creator
var damage = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("default")
	if direction == 0 : direction = -1
	scale.x = direction
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.y = creator.global_position.y 
	global_position.x = creator.global_position.x + (direction*25)
	pass


func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	if(body.has_method("hubris_take_damage")):
		body.hubris_take_damage(damage)
	pass # Replace with function body.
