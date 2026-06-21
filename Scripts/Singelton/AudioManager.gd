extends Node

var sfx_library = {
	"gun": preload("res://SFX/pistol_shot.wav"),
	"shotgun": preload("res://SFX/shotgun_shot.wav"),
	"flame": preload("res://SFX/Flame.wav"),
	"launch": preload("res://SFX/Launcher.wav"),
	"explotion": preload("res://SFX/Explotion.wav"),
	"ding": preload("res://SFX/ding.mp3"),
	"pDamage": preload("res://SFX/damage.mp3"),
	"hubirsLaser": preload("res://SFX/hubrisLaser.mp3"),
	"dead": preload("res://SFX/DeadSound.mp3"),
	"impact": preload("res://SFX/Impact.mp3")
}

# Pool de reproductores
# Asi puede haber varios sonando a la vez
var reproductores: Array[AudioStreamPlayer] = []
const POOL_SIZE = 20 #Aumentar si se satura muy rapido

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	for i in POOL_SIZE:
		var p = AudioStreamPlayer.new()
		add_child(p)
		reproductores.append(p)
		

func play_sfx(sound_name: String, volumen: float = 0.0):
	if not sfx_library.has(sound_name):
		push_warning("No se encontro: " + sound_name)
		return
	var player = _get_free_player()
	player.stream = sfx_library[sound_name]
	player.volume_db = volumen
	player.play()

func _get_free_player() -> AudioStreamPlayer:
	for p in reproductores:
		if not p.playing:
			return p
	# volver al inicio si no hay
	return reproductores[0]
