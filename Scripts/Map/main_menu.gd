extends Control

@onready var startButton = $VBoxContainer/Start
@onready var controlsButton = $VBoxContainer/Controls
@onready var scoreButton = $VBoxContainer/Scores
@onready var exitButton = $VBoxContainer/Exit
@onready var timer = $DramaticEffectTimer
@onready var textureR = $TextureRect

@export var sand = preload("res://Assets/Decoration/sand.png")
@export var soil = preload("res://Assets/Decoration/soil3.png")

var toDo: String

func _ready() -> void:
	if(MusicManager.stopMusic):
		MusicManager.resumeMusic()
	if GlobalGamePlayVariables.currentMap == "Desert":
		textureR.texture = sand  
	else:
		textureR.texture = soil 

func _on_start_pressed() -> void:
	MusicManager.pauseMusic()
	AudioManager.play_sfx("shotgun")
	toDo = "Play"
	startButton.disabled = true
	timer.start(2.0)


func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Scenario/credits_controls.tscn")
	pass


func _on_scores_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Scenario/leader_board_show.tscn")
	pass


func _on_exit_pressed() -> void:
	get_tree().quit()
	pass


func _on_dramatic_effect_timer_timeout() -> void:
	MusicManager.resumeMusic()
	match toDo:
		"Play":
			GlobalGamePlayVariables.restartVariables()
			get_tree().change_scene_to_file("res://Scenes/Scenario/Scenario.tscn")
		pass


func _on_start_mouse_entered() -> void:
	AudioManager.play_sfx("ding",5.0)


func _on_controls_mouse_entered() -> void:
	AudioManager.play_sfx("ding",5.0)


func _on_scores_mouse_entered() -> void:
	AudioManager.play_sfx("ding",5.0)


func _on_exit_mouse_entered() -> void:
	AudioManager.play_sfx("ding",5.0)
