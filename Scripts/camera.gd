extends Camera2D

@onready var player = get_tree().get_first_node_in_group("Player")
const SMOOTH : float = 5

func _process(delta: float) -> void:
	if player:
		global_position.x = lerp(global_position.x, player.global_position.x, SMOOTH*delta)
		global_position.y = lerp(global_position.y, player.global_position.y, SMOOTH*delta)
