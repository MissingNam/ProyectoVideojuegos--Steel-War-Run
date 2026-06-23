extends CanvasLayer



@onready var colorR = $ColorRect
@onready var sand = $Sand
@onready var rain = $Rain

var currentClime = "Clear"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ClimeManager.weather_change.connect(clime_change)
	colorR.hide()
	colorR.color.a = 0.0

func clime_change(clime: String ):
	if(clime == "Sand" and currentClime != "Sand"):
		startSand()
	elif(clime == "Rain" and currentClime != "Rain"):
		startRain()
	elif (clime == "Clear"):
		stopClime()
	currentClime = clime

func _process(delta: float):
	if(currentClime != "Clear" and colorR.color.a < 0.57):
		colorR.color.a += 0.001 
	elif(currentClime == "Clear" and colorR.color.a > 0.0):
		colorR.color.a -= 0.001 
	
	if(colorR.color.a <= 0.0 and currentClime == "Clear"):
		colorR.hide()

func startSand():
	colorR.color = Color(0.635,0.537,0.368,0.0)
	colorR.show()
	sand.emitting = true

func startRain():
	colorR.color = Color(0.259, 0.259, 0.322, 0.0)
	colorR.show()
	rain.emitting = true

func stopClime():
	sand.emitting = false
	rain.emitting = false
