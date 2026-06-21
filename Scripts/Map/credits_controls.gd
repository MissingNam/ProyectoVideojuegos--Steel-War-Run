extends Control

@onready var button = $TextureButton




func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Scenario/main_menu.tscn")


func _on_texture_button_mouse_entered() -> void:
	AudioManager.play_sfx("ding")
