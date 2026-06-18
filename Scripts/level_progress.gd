extends CanvasLayer

class_name xpGUIIndicator

@onready var levelLabel = $Control/LevelLabel
@onready var xpBar = $Control/XPBar
@onready var healthBar = $Control/HealthBar

@onready var gunLabel = $Control/PistolaLabel
@onready var shotLabel = $Control/EscopetaLabel
@onready var flameLabel = $Control/FlamaLabel
@onready var misilLabel = $Control/MisilLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var xp_style = xpBar.get_theme_stylebox("fill").duplicate()
	xp_style.bg_color = Color.GREEN_YELLOW
	xpBar.add_theme_stylebox_override("fill", xp_style)

	var hp_style = healthBar.get_theme_stylebox("fill").duplicate()
	hp_style.bg_color = Color.DARK_RED
	healthBar.add_theme_stylebox_override("fill", hp_style)

	update_ui()
	update_health()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func update_health():
	healthBar.value = GlobalGamePlayVariables.PlayerHealth
	healthBar.max_value = GlobalGamePlayVariables.maxPlayerhealth

func update_ammo():
	gunLabel.text = "Pistola: "+str(GlobalGamePlayVariables.player_BasicBullet)
	shotLabel.text = "Escopeta: "+str(GlobalGamePlayVariables.player_shotGunBullet)
	flameLabel.text = "Lanzallamas: "+str(GlobalGamePlayVariables.player_FlameBullet)
	misilLabel.text = "Bazooka: "+str(GlobalGamePlayVariables.player_RocketBullet)
	

func update_ui():
	levelLabel.text = "Nivel: "+str(GlobalGamePlayVariables.level)
	xpBar.max_value = GlobalGamePlayVariables.xp_to_next_level
	xpBar.value = GlobalGamePlayVariables.player_xp
