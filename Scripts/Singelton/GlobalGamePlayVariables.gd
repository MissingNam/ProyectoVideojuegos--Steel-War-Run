extends Node

signal level_up_triggered(options: Array)
signal gamePaused()
signal playerDied()
signal updateUi()
signal boss_started()
signal boss_finished()

# Jugador
var level : int = 1
var player_xp : int = 0
var xp_to_next_level : int = 10
var player_BasicBullet: int = 10
var player_FlameBullet: int = 0
var player_RocketBullet: int = 0
var player_shotGunBullet: int = 0
var chunkRandSeed = Time.get_time_dict_from_system()
var maxPlayerhealth: int = 3
var PlayerHealth : int = 0
var i_frames : float = 0.5
var usedCheats : bool = false

#Multiplicadores de Armas:
var gunDamageMultiplier: float = 1.0
var gunFirerateMultiplier: float = 0.0
var shotgunDamageMultiplier: float = 1.0
var shotgunFirerateMultiplier: float = 0.0
var flamethrowerDamageMultiplier: float = 1.0
var flamethrowerFirerateMultiplier: float = 0.0
var missileDamageMultiplier: float = 1.0
var missileFirerateMultiplier: float = 0.0

#Contadores
var kills: int = 0
var improvements : int = 0
var bosses : int = 0

#Mapa
var currentMap = "Mountain"

var activeHubris = false
var hubirsDefeated = false

const WEAPON_NAMES := ["Basic", "Shotgun", "Flamethrower", "Rocketlauncher"]
const WEAPON_VAR_PREFIX := ["gun", "shotgun", "flamethrower", "missile"]

var xpGUI : xpGUIIndicator

func _ready():
	var xpGUITree = get_tree().get_nodes_in_group("XPGUI")
	if(xpGUITree): xpGUI = xpGUITree[0]
	#Mapa
	if randi_range(0,1) == 0:
		currentMap = "Mountain"
	else:
		currentMap = "Desert"
	
	
func playerHealthAlterated():
	if(!xpGUI): xpGUI = get_tree().get_first_node_in_group("XPGUI")
	xpGUI.update_health()

func addExpirience(exp : int):
	player_xp += exp
	updateUi.emit()
	if player_xp >= xp_to_next_level:
		player_xp -= xp_to_next_level
		level += 1
		xp_to_next_level = int(xp_to_next_level * 1.25)
		
		var options = generate_upgrade_options()
		level_up_triggered.emit(options)
		get_tree().paused = true

func actualizeAmmo():
	if(!xpGUI): xpGUI = get_tree().get_first_node_in_group("XPGUI")
	xpGUI.update_ammo()
	
func getRandSeed():
	return (chunkRandSeed.hour * chunkRandSeed.minute / (chunkRandSeed.second+1)) + chunkRandSeed.second



func generate_upgrade_options() -> Array:
	var options: Array = []
	# --- Opción 1: vida o invulnerabilidad (siempre esta categoría) ---
	if randf() < 0.5:
		options.append({
		"text": "Incrementa la Vida Máxima",
		"type": "health"
		})
	else:
		options.append({
		"text": "Incrementa los \n frames de Invulnerabilidad",
		"type": "iframes"
		})
	
	# --- Opciones 2 y 3: arma + tipo + porcentaje, al azar ---
	for i in 2:
		var weapon_index = randi() % 4
		var weapon_name = WEAPON_NAMES[weapon_index]
		var var_prefix = WEAPON_VAR_PREFIX[weapon_index]
		var is_damage = randf() < 0.5
		var percent = randf_range(0.05, 0.25)
		var percent_rounded = roundf(percent * 100)  
		
		var stat_text = "Daño de Arma" if is_damage else "Frecuencia de Disparo"
		var var_suffix = "DamageMultiplier" if is_damage else "FirerateMultiplier"
		
		if(weapon_name == "Flamethrower" and not is_damage):
			options.append({
				"text": "Incremento de \n Daño por Segundo \n en: Fuego +%d%%" % [percent_rounded],
				"type": "weapon_stat",
				"variable": var_prefix + var_suffix,  # ej: "gunDamageMultiplier"
				"amount": percent
			})
		else:
			options.append({
				"text": "Incremento de \n %s \n en: %s +%d%%" % [stat_text, weapon_name, percent_rounded],
				"type": "weapon_stat",
				"variable": var_prefix + var_suffix,  # ej: "gunDamageMultiplier"
				"amount": percent
			})
	return options
	
	
func apply_upgrade(option: Dictionary) -> void:
	match option["type"]:
		"health":
			maxPlayerhealth += 1
			playerHealthAlterated()
		"iframes":
			i_frames += 0.1
		"weapon_stat":
			var var_name = option["variable"]
			set(var_name, get(var_name) + option["amount"])
	get_tree().paused = false
	improvements += 1
	print(GlobalGamePlayVariables.flamethrowerFirerateMultiplier)

func pauseGame():
	gamePaused.emit()
	
func player_died():
	playerDied.emit()

func restartVariables():
	level = 1
	player_xp= 0
	xp_to_next_level= 10
	player_BasicBullet= 10
	player_FlameBullet= 0
	player_RocketBullet= 0
	player_shotGunBullet = 0
	chunkRandSeed = Time.get_time_dict_from_system()
	maxPlayerhealth = 3
	PlayerHealth = 0
	i_frames = 0.5
	#Multiplicadores de Armas:
	gunDamageMultiplier = 1.0
	gunFirerateMultiplier = 0.0
	shotgunDamageMultiplier = 1.0
	shotgunFirerateMultiplier = 0.0
	flamethrowerDamageMultiplier = 1.0
	flamethrowerFirerateMultiplier= 0.0
	missileDamageMultiplier = 1.0
	missileFirerateMultiplier = 0.0
	activeHubris = false
	#Contadores
	kills = 0
	improvements = 0
	bosses = 0
	#Mapa
	if randi_range(0,1) == 0:
		currentMap = "Mountain"
	else:
		currentMap = "Desert"
