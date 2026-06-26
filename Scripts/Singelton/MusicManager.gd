extends Node

var desert_music_library = {
	1: preload("res://Music/4S.mp3"),
	2: preload("res://Music/Backgrounds.mp3"),
	3: preload("res://Music/Darkness.mp3"),
	4: preload("res://Music/Desert.mp3")
}

var mountain_music_library = {
	0: preload("res://Music/SFTDP.mp3"),
	1: preload("res://Music/Graze.mp3"),
	2: preload("res://Music/SBR.mp3")
}

var boss_music = {
	0: preload("res://Music/SecondWarning.mp3"),
	1: preload("res://Music/Firepower.mp3"),
	2: preload("res://Music/Falling.mp3"),
	3: preload("res://Music/Hurry Up.wav")
}

var reproducer : AudioStreamPlayer
var stopMusic := false
var changing_music := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	reproducer = AudioStreamPlayer.new()
	add_child(reproducer)

	GlobalGamePlayVariables.boss_started.connect(play_boss_music)	
	GlobalGamePlayVariables.boss_finished.connect(transition_from_boss)
	play_map_music()

func _process(_delta: float) -> void:
	if stopMusic:
		return

	if reproducer.playing:
		return

	if changing_music:
		return

	play_map_music()

func play_map_music() -> void:
	if GlobalGamePlayVariables.currentMap == "Desert":
		reproducer.stream = desert_music_library[randi_range(1,4)]
	else:
		reproducer.stream = mountain_music_library[randi_range(0,2)]

	reproducer.volume_db = 0.0
	reproducer.play()

func play_boss_music() -> void:
	if changing_music:
		return

	changing_music = true

	var tween = create_tween()
	tween.tween_property(reproducer, "volume_db", -40.0, 1.5)

	await tween.finished

	reproducer.stop()

	reproducer.stream = boss_music[randi_range(0,2)]
	reproducer.volume_db = -40.0
	reproducer.play()

	var tween2 = create_tween()
	tween2.tween_property(reproducer, "volume_db", 0.0, 1.5)

	await tween2.finished

	changing_music = false

func transition_from_boss() -> void:
	if changing_music:
		return

	changing_music = true

	var tween = create_tween()
	tween.tween_property(reproducer, "volume_db", -40.0, 2.0)
	await tween.finished
	reproducer.stop()

	if GlobalGamePlayVariables.currentMap == "Desert":
		reproducer.stream = desert_music_library[randi_range(1,4)]
	else:
		reproducer.stream = mountain_music_library[randi_range(0,2)]

	reproducer.volume_db = -40.0
	reproducer.play()

	var tween2 = create_tween()
	tween2.tween_property(reproducer, "volume_db", 0.0, 1.5)
	await tween2.finished
	changing_music = false

func stop():
	reproducer.stop()

func pauseMusic():
	stop()
	stopMusic = true

func resumeMusic():
	stopMusic = false
