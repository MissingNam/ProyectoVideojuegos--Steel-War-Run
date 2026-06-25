extends Node2D

@onready var player_ref : Player
@onready var sprite = $AnimatedSprite2D
@onready var timer = $Timer
@export var explotion = preload("res://Scenes/BossRelated/hubris_explotion.tscn")
var move_speed = 2

var health = 1000 * pow(1.05,GlobalGamePlayVariables.level-17)
var ogHealth = health
var halfway := false

var chargingLaser = false


var resolucion_base = Vector2i(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)


func _ready() -> void:
	GlobalGamePlayVariables.activeHubris = true
	sprite.play("Fase1")
	player_ref = get_tree().get_first_node_in_group("Player")


func _process(delta: float) -> void:
	if(!player_ref): return
	var distanceToPlayer = global_position.distance_to(player_ref.global_position)
	if(distanceToPlayer > 650 or distanceToPlayer < 200):
		move_speed = 10
	elif (distanceToPlayer >= 250):
		move_speed = 2
	
	
	global_position.y = move_toward(global_position.y,player_ref.global_position.y - 250,move_speed) 
	global_position.x = move_toward(global_position.x,player_ref.global_position.x,move_speed)

func hubris_take_damage(damage: float):
	sprite.modulate = Color.ORANGE_RED
	timer.start(0.05)
	health -= damage
	AudioManager.play_sfx("impact",-2.0)
	if(health <= ogHealth/2 and not halfway):
		halfway = true
		var explode = explotion.instantiate()
		explode.global_position = global_position
		explode.global_position.y += 20
		get_tree().root.add_child(explode)
		sprite.play("Fase2")
	if(health <= 0):
		var explode = explotion.instantiate()
		explode.global_position = global_position
		explode.global_position.y += 20
		get_tree().root.add_child(explode)
		GlobalGamePlayVariables.hubirsDefeated = true
		player_ref.cannonTimer.start(15.0)
		queue_free()
		GlobalGamePlayVariables.bosses += 1
		var mejoras = GlobalGamePlayVariables.generate_upgrade_options()
		GlobalGamePlayVariables.activeHubris = false
		GlobalGamePlayVariables.level_up_triggered.emit(mejoras)
		get_tree().paused = true
	
	pass


func _on_timer_timeout() -> void:
	sprite.modulate = Color.WHITE
	pass 
