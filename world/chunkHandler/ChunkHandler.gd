extends Node2D


const chunk = preload("res://world/chunk/Chunk.tscn")

var chunk_deleted_blocks = {}
var chunk_corner_states = {}

var center_chunk = Vector2(0,0)
const CHUNK_GROUP_SIZE = 2
var current_chunks = []

func _ready():
	set_physics_process(true)
	_spawn_chunks()

func _physics_process(delta):
	update_chunks()

func update_chunks():
	var chunk_horizontal_lenght = ChunkDefinition.BLOCK_SIZE * ChunkDefinition.CHUNK_WIDTH
	var chunk_vertical_lenght = ChunkDefinition.BLOCK_SIZE * ChunkDefinition.CHUNK_HEIGHT
	
	var changed = false
	
	if PlayerInfo.position.x > center_chunk.x * chunk_horizontal_lenght + chunk_horizontal_lenght / 2:
		center_chunk.x = center_chunk.x + 1
		changed = true
	elif PlayerInfo.position.x < center_chunk.x * chunk_horizontal_lenght - chunk_horizontal_lenght / 2:
		center_chunk.x = center_chunk.x - 1
		changed = true
	
	if changed:
		print("CHANGED")
		_despawn_chunks()
		_spawn_chunks()
	
	print(self.get_child_count())

func _spawn_chunks():
	for x in range(center_chunk.x - CHUNK_GROUP_SIZE, center_chunk.x + CHUNK_GROUP_SIZE):
		for y in range(center_chunk.y - CHUNK_GROUP_SIZE, center_chunk.y + CHUNK_GROUP_SIZE):
			if  y >= 0 and not current_chunks.has(Vector2(x,y)):
				
				
				
				spawn_chunk(Vector2(x,y))
				

func _despawn_chunks():
	for chunk in current_chunks:
		if abs(center_chunk.x - chunk.x) > CHUNK_GROUP_SIZE or abs(center_chunk.y - chunk.y) > CHUNK_GROUP_SIZE:
			despawn_chunk(chunk)
			current_chunks.erase(chunk)

func spawn_chunk(chunk_position: Vector2):
	var chunk_instance = chunk.instance()
	chunk_instance.name = _get_chunk_name(chunk_position)
	
	var deleted_blocks = {}
	if chunk_deleted_blocks.has(chunk_position):
		deleted_blocks = chunk_deleted_blocks[chunk_position]
	
	var corner_states = {}
	if chunk_corner_states.has(chunk_position):
		corner_states = chunk_corner_states[chunk_position]
	
	
	
	chunk_instance.init(chunk_position, deleted_blocks, corner_states)
	
	current_chunks.append(chunk_position)
	
	
	self.call_deferred("add_child", chunk_instance)
#	self.add_child(chunk_instance)
	

func despawn_chunk(chunk_position: Vector2):
	
	var chunk = get_node(_get_chunk_name(chunk_position))
	
	chunk_deleted_blocks[chunk_position] = chunk.get_deleted_blocks()
	chunk_corner_states[chunk_position] = chunk.get_corner_states()
	
	chunk.destroy()

func _get_chunk_name(chunk_position: Vector2) -> String:
	return str(chunk_position.x) + ";" + str(chunk_position.y)
