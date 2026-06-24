extends Area2D

@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var timer = $Timer

var direction: Vector2
var origin: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("default")
	collision.disabled = true
	rotate(direction.angle())

func _process(_delta: float):
	if(!origin): return
	global_position = origin.global_position
	if(timer.time_left < 0.75):
		collision.disabled = false

func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if(body.has_method("take_damage")):
		body.queue_free()
