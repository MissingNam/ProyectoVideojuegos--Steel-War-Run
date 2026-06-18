extends StaticBody2D



var health : float = randf_range(1.0,4.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func take_damage(damage: float):
	health -= damage
	if(health <= 0):
		queue_free()

func player_take_damage(damage: float = 0.5):
	health -= damage
	if(health <= 0):
		queue_free()
