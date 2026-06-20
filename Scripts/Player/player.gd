extends CharacterBody2D

class_name Player
signal game_paused()

@onready var sprite = $AnimatedSprite2D
@onready var arm = $Player_arm
@export var player_bullet: PackedScene
@onready var cooldownTimer = $Timer
@onready var iframeTimer = $IFrameTimer

const SPEED = 200.0

var cooldown: float = 0.5
var currentGun = "Basic"
var shootGunPellets = 4
var hitpoints = 3
var iFrames = false

var canShoot: bool = true

func _physics_process(_delta: float):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	velocity = direction.normalized() * SPEED

	if direction != Vector2.ZERO:
		if sprite.animation != "Walking":
			sprite.play("Walking")
	else:
		if sprite.animation != "Idle":
			sprite.play("Idle")

	# Movimiento del brazo
	arm.global_position.x = global_position.x
	arm.global_position.y = global_position.y

	if get_global_mouse_position().x < global_position.x:
		sprite.flip_h = true
		arm.sprite.offset.y = -5
		arm.sprite.flip_v = true
		arm.weaponSprite.flip_v = true
		arm.weaponSprite.offset.y = -10
	else:
		sprite.flip_h = false
		arm.sprite.offset.y = 5
		arm.sprite.flip_v = false
		arm.weaponSprite.flip_v = false
		arm.weaponSprite.offset.y = -5

	move_and_slide()

func _input(event):
	if event.is_action_pressed("shoot") and canShoot:
		match currentGun:
			"Basic":
				if GlobalGamePlayVariables.player_BasicBullet > 0:
					shootBasic()
					GlobalGamePlayVariables.player_BasicBullet -= 1

			"Shotgun":
				if GlobalGamePlayVariables.player_shotGunBullet > 0:
					shootShotGun()
					GlobalGamePlayVariables.player_shotGunBullet -= 1

			"Rocketlauncher":
				if GlobalGamePlayVariables.player_RocketBullet > 0:
					shootMissile()
					GlobalGamePlayVariables.player_RocketBullet -= 1

			"Knife":
				shootSlash()

		GlobalGamePlayVariables.actualizeAmmo()

	if event.is_action_pressed("weapon1"):
		currentGun = "Basic"

	if event.is_action_pressed("weapon2"):
		currentGun = "Shotgun"

	if event.is_action_pressed("weapon3"):
		currentGun = "Rocketlauncher"

	if event.is_action_pressed("weapon4"):
		currentGun = "Flamethrower"

	if event.is_action_pressed("weapon5"):
		currentGun = "Knife"

	if event.is_action_pressed("SpawnBoss"):
		get_tree().get_first_node_in_group("EnemySpawner").spawnBoss()
		MusicManager.stop()
		GlobalGamePlayVariables.player_BasicBullet += 1000
		GlobalGamePlayVariables.player_shotGunBullet += 1000
		GlobalGamePlayVariables.player_FlameBullet += 1000
		GlobalGamePlayVariables.player_RocketBullet += 1000
		GlobalGamePlayVariables.maxPlayerhealth += 100
		player_cured(100)
		
	if event.is_action_pressed("pause"):
		GlobalGamePlayVariables.pauseGame()
		

func _process(_delta: float) -> void:
	arm.playerCurrentWeapon = currentGun

	if (
		currentGun == "Flamethrower"
		and Input.is_action_pressed("shoot")
		and canShoot
		and GlobalGamePlayVariables.player_FlameBullet > 0
	):
		shootFire()
		GlobalGamePlayVariables.player_FlameBullet -= 1
		GlobalGamePlayVariables.actualizeAmmo()

func _ready():
	GlobalGamePlayVariables.PlayerHealth = hitpoints

func player_cured(regain: int):
	if hitpoints < GlobalGamePlayVariables.maxPlayerhealth:
		hitpoints += regain
		GlobalGamePlayVariables.PlayerHealth = hitpoints
		GlobalGamePlayVariables.playerHealthAlterated()

func player_take_damage(damage: float):
	if !iFrames:
		AudioManager.play_sfx("pDamage",4.0)
		hitpoints -= damage
		iframeTimer.start(GlobalGamePlayVariables.i_frames)
		sprite.modulate.a = 0.5
		iFrames = true
		GlobalGamePlayVariables.PlayerHealth = hitpoints
		GlobalGamePlayVariables.playerHealthAlterated()

		if hitpoints <= 0:
			AudioManager.play_sfx("dead",3.0)
			GlobalGamePlayVariables.player_died()
			queue_free()

func shootBasic():
	canShoot = false
	AudioManager.play_sfx("gun")
	cooldown = 0.5 - clamp((0.5 * GlobalGamePlayVariables.gunFirerateMultiplier), 0.0, 0.5)

	var location = arm.weaponSprite.global_position
	location.y += 3

	var Bdirection = (get_global_mouse_position() - arm.global_position).normalized()

	PlayerBulletMaker.createBasicPlayerBullet(location, Bdirection)

	cooldownTimer.start(cooldown)

func shootShotGun():
	canShoot = false
	AudioManager.play_sfx("shotgun")
	cooldown = 1.0 - clamp((1.0 * GlobalGamePlayVariables.shotgunFirerateMultiplier), 0.0, 1.0)

	var location = arm.weaponSprite.global_position
	location.y += 3

	var Bdirection = (get_global_mouse_position() - arm.global_position).normalized()

	PlayerBulletMaker.createShotGunBullets(location, Bdirection, shootGunPellets)

	cooldownTimer.start(cooldown)

func shootFire():
	AudioManager.play_sfx("flame")
	canShoot = false
	cooldown = 0.1

	var location = arm.weaponSprite.global_position
	location.y += 3

	var Bdirection = (get_global_mouse_position() - arm.global_position).normalized()

	PlayerBulletMaker.createFlameThrowerFlame(location, Bdirection)

	cooldownTimer.start(cooldown)

func shootMissile():
	canShoot = false
	AudioManager.play_sfx("launch")
	cooldown = 3.5 - clamp((3.5 * GlobalGamePlayVariables.missileFirerateMultiplier), 0.0, 3.5)

	var location = arm.weaponSprite.global_position
	location.y += 3

	var Bdirection = (get_global_mouse_position() - arm.global_position).normalized()

	location += 25 * global_position.direction_to(get_global_mouse_position())

	PlayerBulletMaker.createPlayerMissile(location, Bdirection, 500.0)

	cooldownTimer.start(cooldown)

func shootSlash():
	canShoot = false
	cooldown = 0.5

	var location = arm.weaponSprite.global_position
	location.y += 3

	PlayerBulletMaker.createKnifeSlash(
		location,
		int(get_global_mouse_position().x > global_position.x),
		arm
	)

	cooldownTimer.start(cooldown)

func _on_timer_timeout() -> void:
	canShoot = true

func _on_i_frame_timer_timeout() -> void:
	iFrames = false
	sprite.modulate = Color(1, 1, 1)
