extends Node2D

@export var basic_enemy : PackedScene = preload("res://Scenes/Enemies/BasicEnemy/BasicEnemy.tscn")
@export var streetcleaner: PackedScene = preload("res://Scenes/Enemies/StreetCleaner/StreetCleaner.tscn")
@export var heavy: PackedScene = preload("res://Scenes/Enemies/Heavy/HeavyEnemy.tscn")
@export var sniper : PackedScene = preload("res://Scenes/Enemies/Sniper/Sniper.tscn")
@export var metalGear : PackedScene = preload("res://Scenes/BossRelated/metal_gear_hubris.tscn")

@export var spawn_radius_min := 1000.0
@export var spawn_radius_max := 1400.0

@export var sniper_spawn_radius_min := 1800.0
@export var sniper_spawn_radius_max := 2200.0

@export var cleanup_radius := 3000.0


func _ready():
	randomize()
	$SpawnTimer.wait_time = get_spawn_interval()
	$SpawnTimer.start()
	$CleanupTimer.wait_time = 1.0
	$CleanupTimer.start()

func _process(_delta: float):
	global_position = get_parent().global_position

func get_max_enemies() -> int:
	return min(GlobalGamePlayVariables.level * 4, 100)


func get_spawn_interval() -> float:
	return max(0.15, 1.5 - GlobalGamePlayVariables.level * 0.05)


func get_enemy_weights() -> Dictionary:
	var level = GlobalGamePlayVariables.level
	if level < 4:
		return {
			"basic": 100
		}

	elif level < 7:
		return {
			"basic": 95,
			"streetcleaner": 5
		}

	elif level < 13:
		return {
			"basic": 75,
			"streetcleaner": 15,
			"heavy": 10
		}

	else:
		return {
			"basic": 55,
			"streetcleaner": 20,
			"heavy": 15,
			"sniper": 10
		}
		



func choose_enemy() -> String:
	if(GlobalGamePlayVariables.level >= 15 and not GlobalGamePlayVariables.activeHubris):
		var chance = randi_range(0,100)
		if(chance >= 95):
			return "hubris"
				
	var weights = get_enemy_weights()
	var total_weight = 0
	for weight in weights.values():
		total_weight += weight
	var roll = randi_range(1, total_weight)
	var current = 0
	for enemy_name in weights.keys():
		current += weights[enemy_name]
		if roll <= current:
			return enemy_name
	return "basic"


func spawn_enemy():
	var enemy_type = choose_enemy()
	var enemy_scene : PackedScene
	match enemy_type:
		"basic":
			enemy_scene = basic_enemy
		"streetcleaner":
			enemy_scene = streetcleaner
		"heavy":
			enemy_scene = heavy
		"sniper":
			enemy_scene = sniper
		"hubris":
			enemy_scene = metalGear
	var enemy = enemy_scene.instantiate()
	var distance : float
	if enemy_type == "sniper":
		distance = randf_range(
			sniper_spawn_radius_min,
			sniper_spawn_radius_max
		)
	else:
		distance = randf_range(
			spawn_radius_min,
			spawn_radius_max
		)
	var angle = randf() * TAU
	var offset = Vector2.RIGHT.rotated(angle) * distance
	enemy.global_position = global_position + offset
	get_tree().current_scene.add_child(enemy)


func _on_spawn_timer_timeout():
	$SpawnTimer.wait_time = get_spawn_interval()
	var enemy_count = get_tree().get_nodes_in_group("Enemies").size()
	if enemy_count >= get_max_enemies():
		return
	spawn_enemy()
	
func spawnBoss():
	var enemy = metalGear.instantiate()
	var distance = randf_range(
			spawn_radius_min,
			spawn_radius_max
		)
	var angle = 180
	var offset = Vector2.RIGHT.rotated(angle) * distance
	enemy.global_position = global_position + offset
	get_tree().current_scene.add_child(enemy)


func _on_cleanup_timer_timeout():
	var max_distance_sq = cleanup_radius * cleanup_radius
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if enemy.global_position.distance_squared_to(global_position) > max_distance_sq:
			enemy.queue_free()
