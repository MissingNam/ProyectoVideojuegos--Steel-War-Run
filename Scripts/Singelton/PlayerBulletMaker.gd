extends Node

@export var basicB = preload("res://Scenes/PlayerRelated/player_bullet.tscn")
@export var flame = preload("res://Scenes/PlayerRelated/PlayerFlameThrower.tscn")
@export var missile = preload("res://Scenes/Missile.tscn")
@export var slash = preload("res://Scenes/PlayerRelated/knifeSlash.tscn")

func createBasicPlayerBullet(location : Vector2, angle : Vector2): 
	var newBullet = basicB.instantiate()
	newBullet.global_position = location
	newBullet.global_position.y -= 10
	newBullet.damage = newBullet.damage*GlobalGamePlayVariables.gunDamageMultiplier
	newBullet.direction = angle
	get_tree().root.add_child(newBullet)


func createShotGunBullets(location : Vector2, angle : Vector2, pellets: int = 8):
	for p in pellets:
		var spread = deg_to_rad(randf_range(-15, 15))
		var newBullet = basicB.instantiate()
		newBullet.global_position = location
		newBullet.global_position.y -= 10
		newBullet.direction = angle.rotated(spread)
		newBullet.damage = 0.9
		newBullet.damage = newBullet.damage*GlobalGamePlayVariables.shotgunDamageMultiplier
		newBullet.speed += randf_range(-20, 20)
		get_tree().root.add_child(newBullet)
	

func createFlameThrowerFlame(location: Vector2, angle: Vector2):
	var newFlame = flame.instantiate()
	newFlame.global_position = location
	newFlame.global_position.y -= 10
	newFlame.direction = angle
	newFlame.damage = newFlame.damage*GlobalGamePlayVariables.flamethrowerDamageMultiplier
	get_tree().root.add_child(newFlame)
	
func createPlayerMissile(location: Vector2, angle: Vector2, speed: float):
	var newMissile = missile.instantiate()
	newMissile.global_position = location
	newMissile.global_position.y -= 10
	newMissile.speed = speed
	newMissile.damage = newMissile.damage*GlobalGamePlayVariables.missileDamageMultiplier
	newMissile.direction = angle
	get_tree().root.add_child(newMissile)
	
func createKnifeSlash(location: Vector2, direction: float, creator):
	var newSlash = slash.instantiate()
	newSlash.global_position = location
	newSlash.direction = direction
	newSlash.creator = creator
	get_tree().root.add_child(newSlash)
	
