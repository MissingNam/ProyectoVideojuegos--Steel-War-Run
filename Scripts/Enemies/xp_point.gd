extends Area2D

@onready var sprite = $AnimatedSprite2D
var xpValue: int = 1
var creator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = creator.global_position
	sprite.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		AudioManager.play_sfx("ding",2.0)
		GlobalGamePlayVariables.addExpirience(xpValue)
		queue_free()


func _on_timer_timeout() -> void:
	
	queue_free()
	pass # Replace with function body.
