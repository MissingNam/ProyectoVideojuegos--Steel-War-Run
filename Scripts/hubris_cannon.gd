extends Node2D

@onready var player_ref : Player
@onready var sprite = $Sprite2D
@onready var cooldown = $Timer
var firstCall := false
@export var laser = preload("res://Scenes/BossRelated/Laser.tscn")
var savedDirection
var waitTime = 0

var overcharge = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("default")
	player_ref = get_tree().get_nodes_in_group("Player")[0]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(!player_ref): return
	if(waitTime > 0):
		waitTime -= 1
	if(!firstCall and waitTime == 0):
		look_at(player_ref.global_position)
	pass


func _on_timer_timeout() -> void:
	if(!player_ref): return
	if(!firstCall):
		if(get_parent().halfway):
			var rand = randi_range(0,100)
			if(rand >= 90): overcharge = true
		firstCall = true
		cooldown.start(2.0)
		if not overcharge: sprite.play("ready") 
		else: sprite.play("overcharge")
		savedDirection = global_position.direction_to(player_ref.global_position).angle()
	else:
		var newLaser = laser.instantiate()
		newLaser.direction = savedDirection
		newLaser.global_position = global_position
		newLaser.origin = self
		cooldown.start(randf_range(5.0,10.0) + (int(overcharge)*3.0)) 
		if(overcharge):
			newLaser.redSprite = true
			newLaser.pdamage = 5.0
			newLaser.damage = 100.0
			overcharge = false
		get_tree().root.add_child(newLaser)
		firstCall = false
		sprite.play("default")
		waitTime = 40
		pass # Replace with function body.
