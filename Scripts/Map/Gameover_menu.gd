extends CanvasLayer

@onready var levelLabel = $Control/VBoxContainer/LevelLabel
@onready var XPLabel = $Control/VBoxContainer/XPLabel
@onready var KillsLabel = $Control/VBoxContainer/KillsLabel
@onready var BossLabel = $Control/VBoxContainer/BossesLabel
@onready var ScoreLabel = $Control/ScoreLabel
@onready var button = $Control/MenuButton
@onready var highScoreLabel = $Control/HighScore
@onready var nameButton = $Control/NameButton
@onready var nameLine = $Control/LineEdit

@onready var timer = $DramaticEffectTimer

var effectCounter : = 0
var score : int = 0
var current : String = "Level"

func _ready() -> void:
	nameButton.disabled = true
	highScoreLabel.hide()
	nameLine.hide()
	GlobalGamePlayVariables.playerDied.connect(beginEnd)
	button.disabled = true
	hide()
	pass

func beginEnd():
	show()
	timer.start(2.0)

func _on_menu_button_pressed() -> void:
	MusicManager.pauseMusic()
	get_tree().change_scene_to_file("res://Scenes/Scenario/main_menu.tscn")

func _on_menu_button_mouse_entered() -> void:
	AudioManager.play_sfx("ding")

func _on_dramatic_effect_timer_timeout() -> void:
	match current:
		"Level":
			showLevel()
		"Xp":
			showXp()
		"Kills":
			showKills()
		"Bosses":
			showBosses()
		"Score":
			showScore()
	pass 
	
func showLevel():
	levelLabel.text = str("level: ",effectCounter)
	if(effectCounter < GlobalGamePlayVariables.level):
		effectCounter += 1
		levelLabel.text = str("level: ",effectCounter)
		timer.start(0.1)
	else:
		AudioManager.play_sfx("impact")
		score += 100 * effectCounter
		current = "Xp"
		effectCounter = 0
		timer.start(0.1)

func showXp():
	XPLabel.text = str("xp: ",effectCounter)
	if(effectCounter < GlobalGamePlayVariables.totalXp):
		effectCounter += 1
		XPLabel.text = str("xp: ",effectCounter)
		timer.start(0.001)
	else:
		AudioManager.play_sfx("impact")
		score += 10 * effectCounter
		current = "Kills"
		effectCounter = 0
		timer.start(0.1)
		pass

func showKills():
	KillsLabel.text = str("kills: ",effectCounter)
	if(effectCounter < GlobalGamePlayVariables.kills):
		effectCounter += 1
		KillsLabel.text = str("kills: ",effectCounter)
		timer.start(0.001)
	else:
		AudioManager.play_sfx("impact")
		score += 10 * effectCounter
		current = "Bosses"
		effectCounter = 0
		timer.start(0.1)
		pass

func showBosses():
	BossLabel.text = str("bosses: ",effectCounter)
	if(effectCounter < GlobalGamePlayVariables.bosses):
		effectCounter += 1
		BossLabel.text = str("bosses: ",effectCounter)
		timer.start(0.1)
	else:
		AudioManager.play_sfx("impact")
		score += 1000 * effectCounter
		current = "Score"
		effectCounter = 0
		timer.start(0.1)
		
func showScore():
	ScoreLabel.text = str("score: " ,effectCounter)
	if(effectCounter < score):
		effectCounter += 10
		ScoreLabel.text = str("score: ",effectCounter)
		timer.start(0.001)
	else:
		AudioManager.play_sfx("impact")
		button.disabled = false
		checkLeaderboard()
		pass


func checkLeaderboard():
	if Leaderboard.is_high_score(score):
		highScoreLabel.show()
		nameLine.show()
		nameButton.disabled = false
	else:
		pass

func _on_name_button_pressed() -> void:
	nameButton.disabled = true
	Leaderboard.add_score(nameLine.text, score)
