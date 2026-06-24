extends Node2D

@onready var sprite = $Sprite2D
@onready var weaponSprite = $WeaponSprite

var pistol = load("res://Assets/ProtagonistRelated/PlayerWeapons/pistol.png")
var knife = load("res://Assets/ProtagonistRelated/PlayerWeapons/knife.png")
var flamethrower = load("res://Assets/ProtagonistRelated/PlayerWeapons/flamethrower.png")
var rocketlauncher = load("res://Assets/ProtagonistRelated/PlayerWeapons/rocket_launcher.png")
var shotgun = load("res://Assets/ProtagonistRelated/PlayerWeapons/shotgun.png")
var unloadRailcannon = load("res://Assets/ProtagonistRelated/RailCannon/RailCannon2.png")
var loadRailCannon = load("res://Assets/ProtagonistRelated/RailCannon/RailCannon1.png")
var playerCurrentWeapon = "Basic"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match playerCurrentWeapon:
		"Basic": weaponSprite.texture = pistol
		"Shotgun": weaponSprite.texture = shotgun
		"Flamethrower": weaponSprite.texture = flamethrower
		"Rocketlauncher": weaponSprite.texture = rocketlauncher
		"Knife": weaponSprite.texture = knife
		"RailCannon": 
			if(get_parent().chargedRailCannon):
				weaponSprite.texture = loadRailCannon
			else:
				weaponSprite.texture = unloadRailcannon
			
	look_at(get_global_mouse_position())
