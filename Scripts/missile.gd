extends Area2D

@export var explosion = preload("res://Scenes/MissileExplosion.tscn")

var speed = 500.0
var direction := Vector2.ZERO
var damage: float = 0.5

func _ready() -> void:
	rotation = direction.angle()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += direction * speed * delta

func blowUp():
	var explode = explosion.instantiate()
	explode.global_position = global_position
	get_tree().root.add_child(explode)
	
func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		blowUp()
		queue_free()
	if body.has_method("player_take_damage"):
		blowUp()
		queue_free()
	if(body.has_method("hubris_take_damage")):
		blowUp()
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
