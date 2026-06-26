extends Control

@onready var sunburn = $SunBurn
@onready var vankos = $Vanks
@onready var timer = $Timer
var showed = false
func _ready():
	sunburn.modulate.a = 0.0
	vankos.modulate.a = 0.0
	MusicManager.pauseMusic()

func _process(delta: float) -> void:
	
	if(sunburn.modulate.a < 1.0 and not showed):
		sunburn.modulate.a += 0.4*delta
		vankos.modulate.a += 0.4*delta
		if(sunburn.modulate.a >= 1.0): showed = true
	elif (sunburn.modulate.a > 0.0 and showed):
		sunburn.modulate.a -= 0.4*delta
		vankos.modulate.a -= 0.4*delta

func _input(event: InputEvent):
	if(event.is_action_pressed("ui_accept")):
		timer.stop()
		get_tree().change_scene_to_file("res://Scenes/Scenario/main_menu.tscn")

func _on_timer_timeout() -> void:
	MusicManager.resumeMusic()
	get_tree().change_scene_to_file("res://Scenes/Scenario/main_menu.tscn")
