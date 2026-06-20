extends Node2D

var target : Node2D
var parent_sniper : Node2D

@export var distance := 64.0

var blink_timer = 0.0
var visible_state = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float):
	if !is_instance_valid(target):
		queue_free()
		return

	if !is_instance_valid(parent_sniper):
		queue_free()
		return
	
	var progress = 1.0 - (parent_sniper.time_till_shot / parent_sniper.aim_time)
	# Interpola entre 0.5 segundos y 0.05 segundos
	var blink_interval = lerp(0.5, 0.05, progress)
	blink_timer += delta
	if blink_timer >= blink_interval:
		blink_timer = 0
		visible_state = !visible_state
		visible = visible_state
	
	var dir = target.global_position.direction_to(parent_sniper.global_position)
	global_position = target.global_position + dir * distance
