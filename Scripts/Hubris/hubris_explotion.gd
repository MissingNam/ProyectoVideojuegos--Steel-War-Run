extends Node2D

@onready var sprite = $AnimatedSprite2D


func _ready() -> void:
	sprite.play("default")
	AudioManager.play_sfx("explotion")


func _on_timer_timeout() -> void:
	queue_free()
