extends Node2D

@onready var player_ref : Player
@onready var sprite = $Sprite2D
@onready var cooldown = $Timer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_ref = get_tree().get_first_node_in_group("Player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(!player_ref): return
	look_at(player_ref.global_position)
	pass


func _on_timer_timeout() -> void:
	var Sposition = global_position
	Sposition.y += 32
	EnemyBulletMaker.createBasicBullet(global_position,300)
	cooldown.start(randf_range(0.5,2.0))
	pass # Replace with function body.
