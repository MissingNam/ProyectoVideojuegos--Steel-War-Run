extends CharacterBody2D

class_name basic_enemy

@onready var arm = $BasicEnemyHand
@onready var sprite = $AnimatedSprite2D
@onready var coll = $CollisionShape2D
@onready var hitbox = $Hitbox
@onready var player_ref : Player
@onready var cooldown = $Timer

@export var xpParticle = preload("res://Scenes/Items/xp_point.tscn")

var bullet_speed = 100
var speed = 100
var orbit_distance = randf_range(150,300)

var health : float = 3.0 * pow(1.05,GlobalGamePlayVariables.level-1)

func _ready() -> void:
	sprite.play("default")
	hitbox.add_to_group("Enemy")
	player_ref = get_tree().get_nodes_in_group("Player")[0]
	
func take_damage(damage: float) -> void:
	health -= damage
	if(health <= 0.0):
		createXP()
		GlobalGamePlayVariables.kills += 1
		queue_free()

func _physics_process(_delta: float) -> void:
	# Moverse
	if(!player_ref): return
	var to_player = player_ref.global_position - global_position
	var distance = to_player.length()
	var dir_to_player = to_player.normalized()
	
	if distance > orbit_distance + 5: #Acercarse
		velocity = dir_to_player * speed
	elif distance < orbit_distance - 5: #Alejarse
		velocity = -dir_to_player * speed
	else: # Caminar en circulos
		var tangent = Vector2(-dir_to_player.y,dir_to_player.x)
		velocity = (tangent +dir_to_player * 0.05).normalized() * speed
	
	#Mover el brazo
	arm.global_position.x = global_position.x
	arm.global_position.y = global_position.y
	
	if(player_ref.global_position.x < global_position.x):
		sprite.flip_h = true
		arm.sprite.offset.y = -2
		arm.sprite.flip_v = true
		
	else:
		sprite.flip_h = false
		arm.sprite.offset.y = 6
		arm.sprite.flip_v = false
		
	
	if(ClimeManager.is_sandStorm()):
		velocity = velocity * 0.75
	
	move_and_slide()

func _on_timer_timeout() -> void:
	if(!player_ref): return
	var distance = global_position.distance_to(player_ref.global_position)
	if(distance <= 400):
		EnemyBulletMaker.createBasicBullet(global_position,bullet_speed)
		cooldown.start(randf_range(1.0,3.5))
	else:
		cooldown.start(1.0)
	pass 
	
func createXP():
	var xp = xpParticle.instantiate()
	xp.xpValue = 1
	xp.creator = self
	get_tree().root.add_child(xp)

func _on_dead_timer_timeout() -> void:
	
	queue_free()
