extends Area2D

@onready var collision = $CollisionShape2D
@onready var sprite = $AnimatedSprite2D
@onready var timer = $Timer
var firstCall: bool = false
var direction : float
var origin : Node2D
var redSprite = false

var pdamage = 1.0
var damage = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_sfx("hubirsLaser",2.5)
	sprite.play("default")
	rotation = direction
	sprite.speed_scale = 3.5
	if(redSprite): sprite.modulate = Color.RED
	collision.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = origin.global_position
	pass


func _on_body_entered(body: Node2D) -> void:
	if(collision.disabled == false):
		if(body.has_method("player_take_damage")):
			body.player_take_damage(pdamage)
		elif(body.has_method("take_damage")):
			body.take_damage(damage)
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	if(!firstCall):
		collision.disabled = false
		firstCall = true
		timer.start(0.5)
	else:
		queue_free()
	pass # Replace with function body.
