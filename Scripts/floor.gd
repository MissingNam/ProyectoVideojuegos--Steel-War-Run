extends Node2D

func _process(_delta: float) -> void:
	var cam_pos = get_viewport().get_camera_2d().get_screen_center_position()
	global_position.x = round(cam_pos.x / 128.0) * 128.0
	global_position.y = round(cam_pos.y / 128.0) * 128.0
