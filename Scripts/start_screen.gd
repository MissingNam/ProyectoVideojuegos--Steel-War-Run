extends Control

@onready var sunburn = $SunBurn
@onready var vankos = $Vankos
@onready var quit_timer = $QuitTimer
var can_disappear = false

func _ready():
	sunburn.modulate.a = 0.0
	vankos.modulate.a = 0.0
	MusicManager.pauseMusic()

func _process(delta: float) -> void:
	
	if sunburn.modulate.a < 1.0 and !can_disappear:
		sunburn.modulate.a += 0.75*delta
		vankos.modulate.a += 0.75*delta
		
	if can_disappear:
		sunburn.modulate.a -= 0.75*delta
		vankos.modulate.a -= 0.75*delta

func _input(event: InputEvent):
	if(event.is_action_pressed("ui_accept")):
		quit_timer.stop()
		get_tree().change_scene_to_file("res://Scenes/Scenario/main_menu.tscn")
		
func _on_disappear_timer_timeout() -> void:
	can_disappear = true

func _on_timer_timeout() -> void:
	MusicManager.resumeMusic()
	get_tree().change_scene_to_file("res://Scenes/Scenario/main_menu.tscn")
