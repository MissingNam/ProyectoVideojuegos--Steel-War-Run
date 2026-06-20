extends CanvasLayer

@onready var buttons: Array[Button] = [$Button1, $Button2, $Button3]
var current_options: Array = []

func _ready():
	GlobalGamePlayVariables.level_up_triggered.connect(_on_level_up)
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	

func _on_level_up(options: Array) -> void:
	current_options = options
	for i in options.size():
		buttons[i].text = options[i]["text"]
	show()

func _on_button_1_pressed() -> void:
	_select(0)

func _on_button_2_pressed() -> void:
	_select(1)

func _on_button_3_pressed() -> void:
	_select(2)

func _select(index: int) -> void:
	GlobalGamePlayVariables.apply_upgrade(current_options[index])
	hide()
