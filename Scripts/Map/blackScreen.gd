extends ColorRect


var start = false

func _ready() -> void:
	modulate.a = 0.0
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(start):
		modulate.a += 0.01
	
