extends StaticBody2D

var health : float = randf_range(1.0,4.0)

func take_damage(damage: float):
	health -= damage
	if(health <= 0):
		queue_free()

func player_take_damage(damage: float = 0.5):
	health -= damage
	if(health <= 0):
		queue_free()
