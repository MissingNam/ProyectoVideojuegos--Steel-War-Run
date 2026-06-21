extends Node

const LEADERBOARD_DIR = "user://LeaderBoard"
const LEADERBOARD_PATH = "user://LeaderBoard/scores.json"
const MAX_ENTRIES = 10

#La estructura es Nombre: Score

func _ensure_directory_exists() -> void:
	if not DirAccess.dir_exists_absolute(LEADERBOARD_DIR):
		DirAccess.make_dir_recursive_absolute(LEADERBOARD_DIR)

func load_leaderboard() -> Array:
	if not FileAccess.file_exists(LEADERBOARD_PATH):
		return []
	
	var file = FileAccess.open(LEADERBOARD_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(content)
	if error != OK:
		push_error("Error al parsear leaderboard.json")
		return []
	
	return json.data

func save_leaderboard(data: Array) -> void:
	_ensure_directory_exists()
	var file = FileAccess.open(LEADERBOARD_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t")) 
	file.close()

func is_high_score(score: int) -> bool:
	var leaderboard = load_leaderboard()
	
	# Si hay menos de 10 entradas, siempre entra
	if leaderboard.size() < MAX_ENTRIES:
		return true
	
	# Si ya hay 10, solo entra si supera al más bajo
	var lowest_score = leaderboard[leaderboard.size() - 1]["score"]
	return score > lowest_score

func add_score(player_name: String, score: int) -> void:
	var leaderboard = load_leaderboard()
	
	leaderboard.append({"name": player_name, "score": score})
	
	# Ordenar
	leaderboard.sort_custom(func(a, b): return a["score"] > b["score"])
	
	# Recortar al top 10
	if leaderboard.size() > MAX_ENTRIES:
		leaderboard.resize(MAX_ENTRIES)
	
	save_leaderboard(leaderboard)
