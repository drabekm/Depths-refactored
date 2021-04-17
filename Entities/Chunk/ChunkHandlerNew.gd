extends Node2D

var chunk = preload("res://Entities/Chunk/ChunkNew.tscn")

var central_chunk : Vector2
var loaded_chunks = {}
const CHUNK_WORLD_SIZE = ChunkDefinition.CHUNK_WORLD_SIZE
const CHUNK_WIDTH = ChunkDefinition.CHUNK_WIDTH
const CHUNK_HEIGHT = ChunkDefinition.CHUNK_HEIGHT
const BLOCK_SIZE = ChunkDefinition.BLOCK_SIZE
const CHUNK_BUFFER_SIZE = 1 # Před kolika chunky se narazí na hranici a musí se 
							# načíst nové (např. 1, znamená že se zaktualizuje,
							# než hráč přijde na poslední chunk

func _ready():
	spawn_new_chunks()
	set_physics_process(true)

func _physics_process(delta):
	var isChanged = false
	
	if has_player_moved_from_center():
		update_chunks()

func has_player_moved_from_center() -> bool:
	var has_moved_away = false
	
	var player_position = PlayerInfo.position
	var player_chunk_position_x = round(player_position.x / (BLOCK_SIZE * CHUNK_WIDTH))
	var player_chunk_position_y = round(player_position.y / (BLOCK_SIZE * CHUNK_WIDTH))
	
	if player_chunk_position_x > central_chunk.x:
		central_chunk.x += 1
		has_moved_away = true
	elif player_chunk_position_x < central_chunk.x :
		central_chunk.x -= 1
		has_moved_away = true
	
	if player_chunk_position_y > central_chunk.y:
		central_chunk.y += 1
		has_moved_away = true
	elif player_chunk_position_y < central_chunk.y :
		central_chunk.y -= 1
		has_moved_away = true
	
	return has_moved_away

func get_chunk_name(x : int, y :int ) -> String:
	return str(x) + "-" + str(y)

func despawn_far_away_chunks():
	var chunks = self.get_children()
	for chunk in chunks:
		if (chunk.chunk_position.x > central_chunk.x + CHUNK_BUFFER_SIZE) || (chunk.chunk_position.x < central_chunk.x - CHUNK_BUFFER_SIZE):
			despawn_chunk(chunk)
		elif (chunk.chunk_position.y > central_chunk.y + CHUNK_BUFFER_SIZE) || (chunk.chunk_position.y < central_chunk.y - CHUNK_BUFFER_SIZE):
			despawn_chunk(chunk)

func despawn_chunk(var chunk):
	var chunk_position = chunk.chunk_position
	if loaded_chunks.has(chunk_position):
		chunk.queue_free()
		loaded_chunks.erase(chunk_position)

func spawn_new_chunks():
	for x in range( central_chunk.x - CHUNK_WORLD_SIZE , central_chunk.x + CHUNK_WORLD_SIZE):
		for y in range(  central_chunk.y - CHUNK_WORLD_SIZE, central_chunk.y + CHUNK_WORLD_SIZE):
			if not loaded_chunks.has(Vector2(x,y)) and y >= 0:
				var new_chunk = chunk.instance()
				new_chunk.name = get_chunk_name(x,y)
				loaded_chunks[Vector2(x,y)] = get_chunk_name(x,y)
				new_chunk.init(Vector2(x,y))
				new_chunk.position = Vector2(x * (CHUNK_WIDTH * BLOCK_SIZE),y * (CHUNK_HEIGHT * BLOCK_SIZE) )
				add_child(new_chunk)

func update_chunks():
	despawn_far_away_chunks()
	spawn_new_chunks()
