extends Node2D

@onready var player_ref : Player
@onready var sprite = $AnimatedSprite2D
@onready var timer = $Timer

@export var explotion = preload("res://Scenes/BossRelated/hubris_explotion.tscn")

# Ahora representa píxeles por segundo
var move_speed : float = 120.0

var health = 500 * pow(1.05, GlobalGamePlayVariables.level - 17)
var ogHealth = health
var halfway := false

var chargingLaser = false

var resolucion_base = Vector2i(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)


func _ready() -> void:
	GlobalGamePlayVariables.activeHubris = true
	GlobalGamePlayVariables.boss_started.emit()

	sprite.play("Fase1")
	print(health)

	player_ref = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if !player_ref:
		return

	var distance_to_player = global_position.distance_to(player_ref.global_position)

	if distance_to_player > 650 or distance_to_player < 200:
		move_speed = 600.0
	elif distance_to_player >= 250:
		move_speed = 120.0

	if player_ref.global_position.y - global_position.y < 200:
		move_speed = 600.0

	global_position.y = move_toward(
		global_position.y,
		player_ref.global_position.y - 250,
		move_speed * delta
	)

	global_position.x = move_toward(
		global_position.x,
		player_ref.global_position.x,
		move_speed * delta
	)

func hubris_take_damage(damage: float) -> void:
	sprite.modulate = Color.ORANGE_RED
	timer.start(0.05)

	health -= damage

	AudioManager.play_sfx("impact", -5.0)

	if health <= ogHealth / 2 and !halfway:
		halfway = true

		var explode = explotion.instantiate()
		explode.global_position = global_position
		explode.global_position.y += 20
		get_tree().root.add_child(explode)

		sprite.play("Fase2")

	if health <= 0:
		var explode = explotion.instantiate()
		explode.global_position = global_position
		explode.global_position.y += 20
		get_tree().root.add_child(explode)

		GlobalGamePlayVariables.hubirsDefeated = true
		player_ref.cannonTimer.start(15.0)

		GlobalGamePlayVariables.bosses += 1
		GlobalGamePlayVariables.activeHubris = false
		GlobalGamePlayVariables.boss_finished.emit()

		var mejoras = GlobalGamePlayVariables.generate_upgrade_options()
		GlobalGamePlayVariables.level_up_triggered.emit(mejoras)

		get_tree().paused = true
		queue_free()


func _on_timer_timeout() -> void:
	sprite.modulate = Color.WHITE
