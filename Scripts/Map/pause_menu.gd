extends CanvasLayer


@onready var resume = $Control/VBoxContainer/ResumeButton
@onready var menu = $Control/VBoxContainer/MenuButton

func _ready():
	GlobalGamePlayVariables.gamePaused.connect(pauseGame)
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	AudioManager.play_sfx("shotgun")
	hide()
	


func _on_menu_button_pressed() -> void:
	hide()
	get_tree().paused = false
	MusicManager.pauseMusic()
	GlobalGamePlayVariables.end_game.emit()
	get_tree().change_scene_to_file("res://Scenes/Scenario/main_menu.tscn")


func _on_resume_button_mouse_entered() -> void:
	AudioManager.play_sfx("ding",5.0)


func _on_menu_button_mouse_entered() -> void:
	AudioManager.play_sfx("ding",5.0)
	
func pauseGame():
	get_tree().paused = true
	show()
