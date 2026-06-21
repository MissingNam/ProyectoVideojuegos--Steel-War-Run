extends Control

@onready var leaderboardLabel = $ScoreContainer/RichTextLabel

func _ready() -> void:
	display_leaderboard()


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Scenario/main_menu.tscn")
	


func _on_menu_button_mouse_entered() -> void:
	AudioManager.play_sfx("ding")
	pass # Replace with function body.


func display_leaderboard() -> void:
	var leaderboard = Leaderboard.load_leaderboard()
	
	leaderboardLabel.clear()
	
	if leaderboard.is_empty():
		leaderboardLabel.append_text("[center]no hay puntajes[/center]")
		return
	
	for i in range(leaderboard.size()):
		var entry = leaderboard[i]
		var rank = i + 1
		var name = entry["name"]
		var score = entry["score"]
		
		var line := ""
		match rank:
			1:
				line = "[color=gold][b]%d. %s - %d[/b][/color]\n" % [rank, name, score]
			2:
				line = "[color=silver][b]%d. %s - %d[/b][/color]\n" % [rank, name, score]
			3:
				line = "[color=orange][b]%d. %s - %d[/b][/color]\n" % [rank, name, score]
			_:
				line = "%d. %s - %d\n" % [rank, name, score]
		
		leaderboardLabel.append_text(line)
