extends Node

@export var blood_scene = preload("res://Scenes/Particles/blood.tscn")
@export var fire_scene = preload("res://Scenes/Particles/fire.tscn")
@export var box_particles_scene = preload("res://Scenes/Particles/box_particles.tscn")
@export var cactus_particles_scene = preload("res://Scenes/Particles/cactus_particles.tscn")
@export var rock_particles_scene = preload("res://Scenes/Particles/rock_particles.tscn")

func create_blood(pos : Vector2) -> void:
	var blood = blood_scene.instantiate()
	blood.global_position = pos
	get_tree().root.add_child(blood)

func create_fire(body : Node2D) -> void:
	var fire = fire_scene.instantiate()
	fire.position = Vector2.ZERO
	body.add_child(fire)

func create_box_particles(pos : Vector2) -> void:
	var box_particles = box_particles_scene.instantiate()
	box_particles.global_position = pos
	get_tree().root.add_child(box_particles)

func create_cactus_particles(pos : Vector2) -> void:
	var cactus_particles = cactus_particles_scene.instantiate()
	cactus_particles.global_position = pos
	get_tree().root.add_child(cactus_particles)
	
func create_rock_particles(pos : Vector2) -> void:
	var rock_particles = rock_particles_scene.instantiate()
	rock_particles.global_position = pos
	get_tree().root.add_child(rock_particles)
