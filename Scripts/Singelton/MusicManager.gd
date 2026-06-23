extends Node


var desert_music_library = {
	1: preload("res://Music/4S.mp3"),
	2: preload("res://Music/Darkness.mp3"),
	3: preload("res://Music/Steel War Run OST Backgrounds.wav"),
	4: preload("res://Music/Desert.mp3")
}

var mountain_music_library = {
	0: preload("res://Music/ClairDeLune.mp3"),
	1: preload("res://Music/Graze.mp3")
	
}

var boss_music = {
	0: preload("res://Music/SecondWarning.mp3"),
	1: preload("res://Music/Firepower.mp3"),
	2: preload("res://Music/Falling.mp3")
}

var reproducer : AudioStreamPlayer
var stopMusic = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	reproducer = AudioStreamPlayer.new()
	add_child(reproducer)
	if(GlobalGamePlayVariables.currentMap == "Desert"):
		reproducer.stream = desert_music_library[randi_range(1,4)]
	else:
		reproducer.stream = mountain_music_library[randi_range(0,1)]
	reproducer.volume_db = 0.0
	reproducer.play()


func _process(_delta:float) -> void:
	if(!stopMusic):
		if not reproducer.playing and not GlobalGamePlayVariables.activeHubris:
			if(GlobalGamePlayVariables.currentMap == "Desert"):
				reproducer.stream = desert_music_library[randi_range(1,4)]
			else:
				reproducer.stream = mountain_music_library[randi_range(0,1)]
			reproducer.play()
		elif not reproducer.playing and GlobalGamePlayVariables.activeHubris:
			reproducer.stream = boss_music[randi_range(0,2)]
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
