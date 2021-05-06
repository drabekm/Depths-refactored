extends Node2D

var chunks = []
var chunks_by_position = {}
var destroyed_blocks_by_chunk_position = {}
var block_statuses_in_chunk = {} 

var central_chunk : Vector2
var previous_central_chunk : Vector2


const CHUNK_PIXEL_SIZE = ChunkDefinition.CHUNK_PIXEL_SIZE
const BLOCK_PIXEL_SIZE = ChunkDefinition.BLOCK_PIXEL_SIZE
const PLAYER_PIXEL_SIZE = 32

func _ready():
	previous_central_chunk = Vector2(0,0)
	central_chunk = Vector2(0,0)
	get_chunks()
	get_chunks_by_position()
	update_chunks()
	set_process(true)

func get_chunks():
	chunks = get_node("Chunks").get_children()
	for chunk in chunks:
		chunk.connect("block_destroyed", self, "block_destroyed_handler")

func get_chunks_by_position():
	for chunk in chunks:
		chunks_by_position[chunk.chunk_position] = chunk

func block_destroyed_handler(block_position : Vector2, chunk_position : Vector2):
	if destroyed_blocks_by_chunk_position.has(chunk_position):
		destroyed_blocks_by_chunk_position[chunk_position].append(block_position)
	else:
		destroyed_blocks_by_chunk_position[chunk_position] = []
		destroyed_blocks_by_chunk_position[chunk_position].append(block_position)
	
	#Update corner status
	handle_block_status_change(block_position, chunk_position)


func handle_block_status_change(var block_position, var chunk_position):
	if block_position.x + 1 == 4: # Update block on right
#		chunks_by_position[Vector2(chunk_position.x + 1, chunk_position.y)].update_block_corner(Vector2(block_position.x + 1, block_position.y), CornerStates.LEFT_MISSING)
		_upsert_block_status(Vector2(block_position.x + 1, block_position.y), Vector2(chunk_position.x + 1, chunk_position.y), CornerStates.LEFT_MISSING)
	else:
#		chunks_by_position[chunk_position].update_block_corner(Vector2(block_position.x + 1, block_position.y), CornerStates.LEFT_MISSING)
		_upsert_block_status(Vector2(block_position.x + 1, block_position.y), chunk_position, CornerStates.LEFT_MISSING)
	
	if block_position.y + 1 == 4:
#		chunks_by_position[Vector2(chunk_position.x, chunk_position.y + 1)].update_block_corner(Vector2(block_position.x, block_position.y + 1), CornerStates.TOP_MISSING)
		_upsert_block_status(Vector2(block_position.x, block_position.y + 1), Vector2(chunk_position.x, chunk_position.y + 1), CornerStates.TOP_MISSING)
	else:
#		chunks_by_position[chunk_position].update_block_corner(Vector2(block_position.x, block_position.y + 1), CornerStates.TOP_MISSING)
		_upsert_block_status(Vector2(block_position.x, block_position.y + 1), chunk_position, CornerStates.TOP_MISSING)

func _upsert_block_status(var block_position, var chunk_position, var status):
	if block_statuses_in_chunk.has(chunk_position):
		if block_statuses_in_chunk[chunk_position].has(block_position):
			block_statuses_in_chunk[chunk_position][block_position] |= status
		else :
			block_statuses_in_chunk[chunk_position][block_position] = status
	else:
		block_statuses_in_chunk[chunk_position] = {}
		block_statuses_in_chunk[chunk_position][block_position] = status
	
#	update_specific_chunk(chunk_position)

func update_specific_chunk(var chunk_position):
	var destroyed_blocks = get_chunks_destroyed_blocks(chunk_position)
	var block_statuses = get_chunk_blocks_statuses(chunk_position)
	chunks_by_position[chunk_position].update_blocks(destroyed_blocks, block_statuses)

func _process(delta):
	var isChanged = false
	if has_player_moved_from_center():
		update_chunks()

func _physics_process(delta):
	pass

func has_player_moved_from_center() -> bool:
	var has_moved_away = false
	
	var player_position = PlayerInfo.position
	
	
	
	var central_chunk_position_right = (CHUNK_PIXEL_SIZE / 2) + (CHUNK_PIXEL_SIZE * central_chunk.x) 
	var central_chunk_position_left =  (-CHUNK_PIXEL_SIZE / 2) + (CHUNK_PIXEL_SIZE * central_chunk.x)
	var central_chunk_position_bottom = (CHUNK_PIXEL_SIZE * central_chunk.y) 
	var central_chunk_position_top = (-CHUNK_PIXEL_SIZE) + (CHUNK_PIXEL_SIZE * central_chunk.y)
	
	#Moving current chunk borders. Only used for debug
#	$ChunkBorder/icon.global_position.x = central_chunk_position_left
#	$ChunkBorder/icon2.global_position.x = central_chunk_position_right
	$ChunkBorder/icon3.global_position.y = central_chunk_position_bottom
	$ChunkBorder/icon4.global_position.y = central_chunk_position_top
	
	if player_position.x - PLAYER_PIXEL_SIZE / 2  > central_chunk_position_right and _player_is_not_drilling() :
		previous_central_chunk = central_chunk
		central_chunk.x += 1
		has_moved_away = true
	elif player_position.x + PLAYER_PIXEL_SIZE / 2  < central_chunk_position_left and _player_is_not_drilling():
		previous_central_chunk = central_chunk
		central_chunk.x -= 1
		has_moved_away = true
#	if player_position.y > 0:
	if player_position.y  > central_chunk_position_bottom and _player_is_not_drilling():
		previous_central_chunk = central_chunk
		central_chunk.y += 1
		has_moved_away = true
	elif player_position.y < central_chunk_position_top and _player_is_not_drilling():
		previous_central_chunk = central_chunk
		central_chunk.y -= 1
		has_moved_away = true

	return has_moved_away

func _player_is_not_drilling() -> bool:
	return !PlayerInfo.is_drilling

func get_chunks_destroyed_blocks(position : Vector2) -> Array:
	if destroyed_blocks_by_chunk_position.has(position):
		return destroyed_blocks_by_chunk_position[position]
	return []

func get_chunk_blocks_statuses(position : Vector2) -> Dictionary:
	if block_statuses_in_chunk.has(position):
		return block_statuses_in_chunk[position]
	return {}

func update_chunks():
	DebugInfo.central_chunk = central_chunk
	var movement = central_chunk - previous_central_chunk
	
	self.position += movement * (4 * BLOCK_PIXEL_SIZE)
	for chunk in chunks:
		chunk.chunk_position.x += movement.x
		chunk.chunk_position.y += movement.y
		var destroyed_blocks = get_chunks_destroyed_blocks(chunk.chunk_position)
		var block_statuses = get_chunk_blocks_statuses(chunk.chunk_position)
		chunk.update_blocks(destroyed_blocks, block_statuses)





