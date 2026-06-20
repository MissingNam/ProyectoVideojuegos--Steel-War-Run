extends StaticBody2D

@onready var sprite = $AnimatedSprite2D
@onready var coll = $CollisionShape2D
var loot : String = "Basic"
var amount : int
var broken : bool = false

func _ready() -> void:
	sprite.play("Box")
	var index = randi_range(0,5)
	match index:
		0: loot = "Basic"
		1: loot = "ShotGun"
		2: loot = "Flame"
		3: loot = "Missile"
		4: loot = "Health"
		5: loot = "Upgrade"
	
	if(index != 3 and index != 4 and index !=2):
		amount = int(randf_range(5, 30))
	elif(index == 3):
		amount = int(randf_range(1,5))
	elif(index == 2):
		amount = int(randf_range(10,45))
	else:
		amount = 1

func take_damage(damage: float) -> void:
	coll.set_deferred("disabled", true)
	match (loot):
		"Basic": sprite.play("Regular")
		"ShotGun": sprite.play("ShootGun")
		"Flame": sprite.play("Flame")
		"Missile": sprite.play("Misile")
		"Health": sprite.play("Medic")
		"Upgrade": sprite.play("Upgrade")
	broken = true
	ParticlesSpawner.create_box_particles(global_position)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player") and broken == true):
		match (loot):
			"Basic": GlobalGamePlayVariables.player_BasicBullet += amount
			"ShotGun": GlobalGamePlayVariables.player_shotGunBullet += amount
			"Flame": GlobalGamePlayVariables.player_FlameBullet += amount
			"Missile": GlobalGamePlayVariables.player_RocketBullet += amount
			"Health": 
				if(body.has_method("player_cured")):
					body.player_cured(amount)
			"Upgrade": 
				var options = GlobalGamePlayVariables.generate_upgrade_options()
				GlobalGamePlayVariables.level_up_triggered.emit(options)
				get_tree().paused = true
		GlobalGamePlayVariables.actualizeAmmo()
		queue_free()
