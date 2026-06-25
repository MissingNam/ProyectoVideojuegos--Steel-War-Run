extends Node2D

class_name ChunkManager

const CHUNK_SIZE := 512    # tamaño en píxeles de cada chunk
const RADIUS := 2          # 1 = grid de 3x3 (8 alrededor + el central)
const UNLOAD_DISTANCE := 3 # en unidades de chunk

var player: Node2D
var loaded_chunks := {}  # Vector2i -> Node2D

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(_delta):
	#MusicManager._checkMusic()
	update_chunks()

func get_chunk_coord(world_pos: Vector2) -> Vector2i:
	return Vector2i(
		floori(world_pos.x / CHUNK_SIZE),
		floori(world_pos.y / CHUNK_SIZE)
	)

func update_chunks():
	if(!player): return
	var player_chunk = get_chunk_coord(player.global_position)
	
	# 1. Generar los que faltan en el radio
	for x in range(-RADIUS, RADIUS + 1):
		for y in range(-RADIUS, RADIUS + 1):
			var coord = player_chunk + Vector2i(x, y)
			if not loaded_chunks.has(coord):
				spawn_chunk(coord)
	
	# 2. Eliminar los lejanos
	var to_remove = []
	for coord in loaded_chunks.keys():
		if coord.distance_to(player_chunk) > UNLOAD_DISTANCE:
			to_remove.append(coord)
	
	for coord in to_remove:
		loaded_chunks[coord].queue_free()
		loaded_chunks.erase(coord)

func spawn_chunk(coord: Vector2i):
	var chunk = preload("res://Scenes/Scenario/ChunkRelated/Chunk.tscn").instantiate()
	add_child(chunk)
	chunk.global_position = Vector2(coord.x * CHUNK_SIZE, coord.y * CHUNK_SIZE)
	loaded_chunks[coord] = chunk
	chunk.generate(coord)  # le pasamos la coordenada para generación determinística
