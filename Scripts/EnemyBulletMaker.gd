extends Node

@onready var player_ref : Player
@export var basicBullet = preload("res://Scenes/Enemies/BasicEnemyBullet.tscn")
@export var streetFire = preload("res://Scenes/Enemies/StreetCleanerFire.tscn")
func _ready():
	
	player_ref = get_tree().get_first_node_in_group("Player")

# Called when the node enters the scene tree for the first time.
func createBasicBullet(location : Vector2, speed : float = 1):
	if(!player_ref): return
	var newBullet = basicBullet.instantiate()
	newBullet.speed = speed
	newBullet.global_position = location
	newBullet.direction = location.direction_to(player_ref.global_position)
	get_tree().root.add_child(newBullet)
	

func createEnemyFlame(location: Vector2, speed:float):
	if(!player_ref): return
	var newFire = streetFire.instantiate()
	newFire.speed = 400
	newFire.global_position = location
	newFire.direction = location.direction_to(player_ref.global_position)
	get_tree().root.add_child(newFire)
