extends Node2D

@onready var player_ref : Player
@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_ref = get_tree().get_nodes_in_group("Player")[0]
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(!player_ref): return
	look_at(player_ref.global_position)
	pass
