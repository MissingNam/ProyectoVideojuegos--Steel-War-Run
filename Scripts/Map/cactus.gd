extends StaticBody2D

var health : float = randf_range(1.0,4.0)
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@export var bush = preload("res://Assets/Decoration/bush.png")

func _ready():
	if(GlobalGamePlayVariables.currentMap == "Mountain"):
		sprite.texture = bush
		collision.scale.x = collision.scale.x*2
		collision.scale.y = collision.scale.y/2

func take_damage(damage: float):
	health -= damage
	if(health <= 0):
		queue_free()

func player_take_damage(damage: float = 0.5):
	health -= damage
	if(health <= 0):
		queue_free()
