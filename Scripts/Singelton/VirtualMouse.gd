extends Node

signal input_mode_changed(mode: InputMode)

enum InputMode { MOUSE, GAMEPAD }

@export var gamepad_cursor_speed: float = 2400.0

## Deadzone del stick derecho para evitar drift
@export var stick_deadzone: float = 0.2

@export var action_aim_right: String = "aim_right"
@export var action_aim_left: String = "aim_left"
@export var action_aim_down: String = "aim_down"
@export var action_aim_up: String = "aim_up"

## Acción que simula el click izquierdo del mouse cuando se usa el control
## (mapéala al botón A/Cross, o al gatillo derecho, lo que prefieras en el InputMap)
@export var action_ui_click: String = "shoot"

var current_mode: InputMode = InputMode.MOUSE

# Posición virtual en coordenadas de pantalla (mismo espacio que get_viewport().get_mouse_position())
var _virtual_screen_pos: Vector2 = Vector2.ZERO
var _last_synced_pos: Vector2 = Vector2.ZERO
var _ui_click_held: bool = false

# Referencia a la cámara actual para convertir screen -> global.
# Se autodetecta, pero puedes asignarla manualmente si tienes varias cámaras.
var camera: Camera2D = null


func _ready() -> void:
	# Inicializa con la posición real del mouse al arrancar
	_virtual_screen_pos = get_viewport().get_mouse_position()
	set_process(true)
	set_process_unhandled_input(true)
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(delta: float) -> void:
	if current_mode == InputMode.GAMEPAD:
		_update_from_gamepad(delta)
		# Mantenemos el cursor real del sistema oculto y "pegado" virtualmente.
		# No usamos warp_mouse para evitar los problemas mencionados arriba.

		# Si la posición cambió, le avisamos al Viewport con un evento de mouse
		# sintético. Esto es lo que hace que los Button/Control nativos de Godot
		# detecten "hover" sin que nosotros calculemos colisiones a mano.
		if _virtual_screen_pos != _last_synced_pos:
			_send_synthetic_motion(_virtual_screen_pos, _virtual_screen_pos - _last_synced_pos)
			_last_synced_pos = _virtual_screen_pos


func _unhandled_input(event: InputEvent) -> void:
	# Filtro crítico: cuando inyectamos un evento con Input.parse_input_event(),
	# ese evento vuelve a pasar por este mismo _unhandled_input. Sin este filtro
	# entraríamos en un loop o, peor, confundiríamos nuestro propio evento
	# sintético con un movimiento "real" de mouse y volveríamos a InputMode.MOUSE
	# justo después de haber cambiado a GAMEPAD. El evento sintético sí sigue
	# su camino hacia el Viewport/Controls (eso pasa antes de llegar aquí);
	# solo evitamos que ESTE script lo reinterprete.
	if event.get_meta("synthetic_from_virtual_cursor", false):
		return

	# Cualquier movimiento de mouse real, o click, regresa al modo MOUSE
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		if current_mode != InputMode.MOUSE:
			_set_mode(InputMode.MOUSE)
		if event is InputEventMouseMotion:
			_virtual_screen_pos = event.position
			_last_synced_pos = event.position

	# Cualquier movimiento del stick derecho (o un botón de gamepad) activa modo GAMEPAD
	elif event is InputEventJoypadMotion:
		if abs(event.axis_value) > stick_deadzone:
			if current_mode != InputMode.GAMEPAD:
				_set_mode(InputMode.GAMEPAD)
	elif event is InputEventJoypadButton:
		if current_mode != InputMode.GAMEPAD:
			_set_mode(InputMode.GAMEPAD)

	# Botón de "click" del control: lo traducimos a click de mouse sintético
	if event.is_action_pressed(action_ui_click) and current_mode == InputMode.GAMEPAD:
		_send_synthetic_click(_virtual_screen_pos, true)
	elif event.is_action_released(action_ui_click) and current_mode == InputMode.GAMEPAD:
		_send_synthetic_click(_virtual_screen_pos, false)


func _update_from_gamepad(delta: float) -> void:
	var dir := Input.get_vector(
		action_aim_left, action_aim_right, action_aim_up, action_aim_down, stick_deadzone
	)
	if dir.length() > 0.0:
		_virtual_screen_pos += dir * gamepad_cursor_speed * delta
		_virtual_screen_pos = _virtual_screen_pos.clamp(Vector2.ZERO, get_viewport().get_visible_rect().size)


func _send_synthetic_motion(pos: Vector2, relative: Vector2) -> void:
	var ev := InputEventMouseMotion.new()
	ev.position = pos
	ev.global_position = pos
	ev.relative = relative
	ev.set_meta("synthetic_from_virtual_cursor", true)
	Input.parse_input_event(ev)


func _send_synthetic_click(pos: Vector2, pressed: bool) -> void:
	var ev := InputEventMouseButton.new()
	ev.position = pos
	ev.global_position = pos
	ev.button_index = MOUSE_BUTTON_LEFT
	ev.pressed = pressed
	ev.set_meta("synthetic_from_virtual_cursor", true)
	Input.parse_input_event(ev)
	_ui_click_held = pressed


func _set_mode(mode: InputMode) -> void:
	current_mode = mode
	emit_signal("input_mode_changed", mode)


## ---------------------------------------------------------------------
## API pública: esto es lo que llamas desde tu jugador y tus menús
## ---------------------------------------------------------------------

## Reemplazo directo de get_global_mouse_position()
func get_aim_position() -> Vector2:
	if current_mode == InputMode.GAMEPAD:
		return _screen_to_global(_virtual_screen_pos)
	return _get_real_global_mouse_position()


## Posición del cursor virtual en coordenadas de pantalla (para dibujar un sprite de cursor en un CanvasLayer)
func get_aim_screen_position() -> Vector2:
	if current_mode == InputMode.GAMEPAD:
		return _virtual_screen_pos
	return get_viewport().get_mouse_position()


func is_using_gamepad() -> bool:
	return current_mode == InputMode.GAMEPAD


func _get_real_global_mouse_position() -> Vector2:
	# Usa la cámara activa si no se asignó una manualmente
	if camera == null:
		camera = get_viewport().get_camera_2d()
	if camera:
		return camera.get_global_mouse_position()
	return get_viewport().get_mouse_position()


func _screen_to_global(screen_pos: Vector2) -> Vector2:
	if camera == null:
		camera = get_viewport().get_camera_2d()
	if camera == null:
		return screen_pos
	# Convierte una posición de pantalla a coordenadas globales del mundo,
	# respetando zoom y posición de la cámara (igual que hace el mouse real).
	var viewport_size := get_viewport().get_visible_rect().size
	var screen_center := viewport_size * 0.5
	var offset := (screen_pos - screen_center) * camera.zoom
	return camera.get_screen_center_position() + offset
