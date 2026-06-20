extends CanvasLayer

class_name xpGUIIndicator

@onready var levelLabel = $Control/LevelLabel
@onready var healthLabel = $Control/HealthLabel
@onready var xpBar = $Control/XPBar
@onready var healthBar = $Control/HealthBar

@onready var gunLabel = $Control/PistolaLabel
@onready var shotLabel = $Control/EscopetaLabel
@onready var flameLabel = $Control/FlamaLabel
@onready var misilLabel = $Control/MisilLabel

@onready var weaponIcons = $WeaponIcons

var xp_style
var hp_style : StyleBoxFlat

func _ready() -> void:
	weaponIcons.modulate.a = 0.6
	levelLabel.modulate.a = 0.6
	healthLabel.modulate.a = 0.6
	xpBar.modulate.a = 0.6
	healthBar.modulate.a = 0.6
	gunLabel.modulate.a = 0.6
	shotLabel.modulate.a = 0.6
	flameLabel.modulate.a = 0.6
	misilLabel.modulate.a = 0.6
	
	xp_style = xpBar.get_theme_stylebox("fill").duplicate()
	xp_style.bg_color = Color.from_rgba8(255, 255, 80)
	xpBar.add_theme_stylebox_override("fill", xp_style)
	
	hp_style = healthBar.get_theme_stylebox("fill").duplicate()
	hp_style.bg_color = Color.from_rgba8(90, 255, 100)
	healthBar.add_theme_stylebox_override("fill", hp_style)

	update_ui()
	update_health()

func update_health():
	healthBar.value = GlobalGamePlayVariables.PlayerHealth
	healthBar.max_value = GlobalGamePlayVariables.maxPlayerhealth

func update_ammo():
	gunLabel.text = str(GlobalGamePlayVariables.player_BasicBullet)
	shotLabel.text = str(GlobalGamePlayVariables.player_shotGunBullet)
	flameLabel.text = str(GlobalGamePlayVariables.player_FlameBullet)
	misilLabel.text = str(GlobalGamePlayVariables.player_RocketBullet)
	
func update_ui():
	levelLabel.text = "Nivel: "+str(GlobalGamePlayVariables.level)
	xpBar.max_value = GlobalGamePlayVariables.xp_to_next_level
	xpBar.value = GlobalGamePlayVariables.player_xp
