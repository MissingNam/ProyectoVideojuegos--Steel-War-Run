extends Node2D

@onready var sprite: Sprite2D = $Sprite2D  # cambia esto al nodo visual que uses
 
 
func _ready() -> void:
	VirtualMouse.input_mode_changed.connect(_on_input_mode_changed)
	_on_input_mode_changed(VirtualMouse.current_mode)
	process_mode = Node.PROCESS_MODE_ALWAYS
 
 
func _process(_delta: float) -> void:
	if VirtualMouse.is_using_gamepad():
		global_position = VirtualMouse.get_aim_screen_position()
 
 
func _on_input_mode_changed(mode: VirtualMouse.InputMode) -> void:
	var using_gamepad := mode == VirtualMouse.InputMode.GAMEPAD
	visible = using_gamepad
	# Oculta el cursor real del sistema mientras se usa el control,
	# y lo restaura cuando vuelve el mouse físico.
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN if using_gamepad else Input.MOUSE_MODE_VISIBLE)
