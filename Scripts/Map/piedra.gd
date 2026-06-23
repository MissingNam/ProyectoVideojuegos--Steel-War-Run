extends StaticBody2D

var health : float = randf_range(4,10)

func take_damage(damage: float):
	health -= damage
	if(health <= 0):
		queue_free()
