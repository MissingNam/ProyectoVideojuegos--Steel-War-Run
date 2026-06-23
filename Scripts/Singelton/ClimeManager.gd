extends Node

signal weather_change(new_weather: String)

var current_weather = "Clear"
var weather_timer = Timer.new()

func _ready() -> void:
	add_child(weather_timer)
	weather_timer.wait_time = randf_range(60.0,180.0)
	weather_timer.autostart = false
	weather_timer.timeout.connect(checkWeather)
	weather_timer.start()


func checkWeather():
	if randf() < 0.2:
		if(GlobalGamePlayVariables.currentMap == "Desert"):
			current_weather = "Sand"
		elif(GlobalGamePlayVariables.currentMap == "Mountain"):
			current_weather = "Rain"
			
		weather_timer.wait_time = randf_range(60.0,120.0)
		weather_timer.start()
	else:
		current_weather = "Clear"
		weather_timer.wait_time = randf_range(60.0,180.0)
		weather_timer.start()
	
	weather_change.emit(current_weather)
	

func is_raining() -> bool:
	return current_weather == "Rain"

func is_sandStorm() -> bool:
	return current_weather == "Sand"
	
func is_clear() -> bool:
	return current_weather == "Clear"
	


func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_down")):
		if(is_clear()):
			if(GlobalGamePlayVariables.currentMap == "Desert"):
				current_weather = "Sand"
			elif(GlobalGamePlayVariables.currentMap == "Mountain"):
				current_weather = "Rain"
		else:
			current_weather = "Clear"
		weather_timer.wait_time = randf_range(60.0,120.0)
		weather_timer.start()
		weather_change.emit(current_weather)
		
