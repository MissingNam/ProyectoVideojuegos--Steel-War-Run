extends Area2D

@onready var sprite = $AnimatedSprite2D

var speed = 400.0
var direction := Vector2.ZERO
var damage = 1.0
var colorFlag : bool = true

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
	if body.has_method("player_take_damage"):
		body.player_take_damage(damage)

func _on_remove_timer_timeout() -> void:
	queue_free()


func _on_switch_color_timer_timeout() -> void:
	if(colorFlag):
		sprite.modulate = Color.RED
		colorFlag = false
	else:
		sprite.modulate = Color.WHITE
		colorFlag = true
	pass # Replace with function body.
