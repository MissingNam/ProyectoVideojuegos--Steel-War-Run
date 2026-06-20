extends CharacterBody2D

class_name sniper

@onready var sprite = $Sprite2D
@onready var shotTimer = $ShotingTimer
@onready var pointTimer = $PointingTimer
@onready var player_ref = Player
@onready var arm = $SniperArm
@export var xpParticle = preload("res://Scenes/xp_point.tscn")

const SPEED = 300.0
var alarma_activa
var time_till_shot = 1.0
var aim_time = 0.0
var health: float = 3.0 * (1.05 * (GlobalGamePlayVariables.level - 13))

func _ready() -> void:
	arm.modulate.a = 0.0
	player_ref = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(delta: float) -> void:
	if(!player_ref): return
	#Mover el brazo
	arm.global_position.x = global_position.x
	arm.global_position.y = global_position.y
	
	if(player_ref.global_position.x < global_position.x):
		sprite.flip_h = false
		#arm.sprite.offset.y = -2
		arm.sprite.flip_v = true
		
	else:
		sprite.flip_h = true
		#arm.sprite.offset.y = 6
		arm.sprite.flip_v = false
	move_and_slide()
	

func _process(delta: float) -> void:
	time_till_shot = shotTimer.time_left

func take_damage(damage: float) -> void:
	health -= damage
	if(health <= 0.0):
		createXP()
		queue_free()

func createSniperAlarm():
	if(!player_ref): return
	var alarm = preload("res://Scenes/Enemies/Sniper/SniperAlarm.tscn").instantiate()
	alarm.target = player_ref
	alarm.parent_sniper = self
	alarma_activa = alarm
	get_tree().current_scene.add_child(alarm)

func _on_shoting_timer_timeout() -> void:
	EnemyBulletMaker.createBasicBullet(global_position,2000)
	sprite.texture = load("res://Assets/EnemyRelated/Sniper/SniperBox.png")
	arm.modulate.a = 0.0
	pointTimer.start(randf_range(10.0, 20.0)) 
	if(alarma_activa): alarma_activa.queue_free()


func _on_pointing_timer_timeout() -> void:
	sprite.texture = load("res://Assets/EnemyRelated/Sniper/SniperOut.png")
	arm.modulate.a = 1.0
	aim_time = randf_range(4.0,6.5)
	shotTimer.start(aim_time)
	createSniperAlarm()
	
func createXP():
	var xp = xpParticle.instantiate()
	xp.xpValue = 2
	xp.creator = self
	get_tree().root.add_child(xp)
