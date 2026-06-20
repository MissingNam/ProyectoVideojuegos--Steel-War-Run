extends Node


var music_library = {
	1: preload("res://Music/4S.mp3"),
	2: preload("res://Music/Darkness.mp3"),
	3: preload("res://Music/Steel War Run OST Backgrounds.wav"),
	4: preload("res://Music/Desert.mp3")
}

var boss_music = {
	0: preload("res://Music/SecondWarning.mp3"),
	1: preload("res://Music/Firepower.mp3")
}

var reproducer : AudioStreamPlayer
var stopMusic = false

func _ready() -> void:
	reproducer = AudioStreamPlayer.new()
	add_child(reproducer)
	reproducer.stream = music_library[randi_range(1,4)]
	reproducer.volume_db = 0.0
	reproducer.play()


func _process(_delta:float) -> void:
	if(!stopMusic):
		if not reproducer.playing and not GlobalGamePlayVariables.activeHubris:
			reproducer.stream = music_library[randi_range(1,4)]
			reproducer.play()
		elif not reproducer.playing and GlobalGamePlayVariables.activeHubris:
			reproducer.stream = boss_music[randi_range(0,1)]
			reproducer.play()
		else:
			pass

func stop():
	reproducer.stop()
	
func pauseMusic():
	stop()
	stopMusic = true
	
func resumeMusic():
	stopMusic = false
