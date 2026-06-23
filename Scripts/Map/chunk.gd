extends Node2D

@export var object_scenes: Array[PackedScene] = []  # cactus, roca, caja
@export var object_weights: Array[float] = [35.0, 20.0, 10.0]
@onready var floor = $TextureRect

@export var sandTexture = preload("res://Assets/Decoration/sand.png")
@export var soilTexture = preload("res://Assets/Decoration/soil3.png")

func generate(coord: Vector2i):
	var rng = RandomNumberGenerator.new()
	rng.seed = hash(coord * GlobalGamePlayVariables.getRandSeed())  # determinístico: mismo coord = mismo seed
	
	place_objects(rng)
	if(GlobalGamePlayVariables.currentMap == "Desert"):
		floor.texture = sandTexture
	elif(GlobalGamePlayVariables.currentMap == "Mountain"):
		floor.texture = soilTexture
	

func pick_weighted_object(rng: RandomNumberGenerator) -> PackedScene:
	var total_weight = 0.0
	for w in object_weights:
		total_weight += w
		
	var roll = rng.randf_range(0, total_weight)
	var accumulated = 0.0
	for i in object_weights.size():
		accumulated += object_weights[i]
		
		if roll <= accumulated:
			return object_scenes[i]
	return object_scenes[-1]  # fallback 

func place_objects(rng: RandomNumberGenerator):
	var num_objects = rng.randi_range(3, 5)
	for i in num_objects:
		var local_pos = Vector2(
			rng.randf_range(0, ChunkManager.CHUNK_SIZE),
			rng.randf_range(0, ChunkManager.CHUNK_SIZE)
		)
		var scene = pick_weighted_object(rng)  
		var obj = scene.instantiate()
		add_child(obj)
		obj.position = local_pos

#func setup_terrain_shader(coord: Vector2i):
#	var mat = $TerrainSprite.material as ShaderMaterial
#	# pasamos la coordenada global del chunk para que el ruido sea continuo
#	mat.set_shader_parameter("chunk_offset", Vector2(coord.x, coord.y) * 512)
