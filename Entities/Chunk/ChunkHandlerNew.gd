extends Node2D

var chunks = []
var destroyed_blocks_by_chunk_position = {}

var central_chunk : Vector2
var previous_central_chunk : Vector2


const CHUNK_PIXEL_SIZE = ChunkDefinition.CHUNK_PIXEL_SIZE
const BLOCK_PIXEL_SIZE = ChunkDefinition.BLOCK_PIXEL_SIZE
const PLAYER_PIXEL_SIZE = 32

func _ready():
	previous_central_chunk = Vector2(0,0)
	get_chunks()
	update_chunks()
	set_process(true)

func get_chunks():
	chunks = get_node("Chunks").get_children()
	for chunk in chunks:
		chunk.connect("block_destroyed", self, "block_destroyed_handler")

func block_destroyed_handler(block_position : Vector2, chunk_position : Vector2):
	if destroyed_blocks_by_chunk_position.has(chunk_position):
		destroyed_blocks_by_chunk_position[chunk_position].append(block_position)
	else:
		destroyed_blocks_by_chunk_position[chunk_position] = []
		destroyed_blocks_by_chunk_position[chunk_position].append(block_position)

func _process(delta):
	var isChanged = false
	
	if has_player_moved_from_center():
		update_chunks()

func has_player_moved_from_center() -> bool:
	var has_moved_away = false
	
	var player_position = PlayerInfo.position
	
	var central_chunk_position_right = CHUNK_PIXEL_SIZE / 2 + CHUNK_PIXEL_SIZE * central_chunk.x 
	var central_chunk_position_left =  (-CHUNK_PIXEL_SIZE / 2) + CHUNK_PIXEL_SIZE * central_chunk.x
	var central_chunk_position_bottom =  CHUNK_PIXEL_SIZE * central_chunk.y 
	var central_chunk_position_top = - CHUNK_PIXEL_SIZE + CHUNK_PIXEL_SIZE * central_chunk.y
	
	#Moving current chunk borders. Only used for debug
	$ChunkBorder/icon.global_position.x = central_chunk_position_left
	$ChunkBorder/icon2.global_position.x = central_chunk_position_right
	$ChunkBorder/icon3.global_position.y = central_chunk_position_bottom
	$ChunkBorder/icon4.global_position.y = central_chunk_position_top
	
	
	
	if player_position.x - PLAYER_PIXEL_SIZE / 2 > central_chunk_position_right :
		previous_central_chunk = central_chunk
		central_chunk.x += 1
		has_moved_away = true
	elif player_position.x + PLAYER_PIXEL_SIZE / 2 < central_chunk_position_left :
		previous_central_chunk = central_chunk
		central_chunk.x -= 1
		has_moved_away = true

	if player_position.y - PLAYER_PIXEL_SIZE / 2 > central_chunk_position_bottom:
		previous_central_chunk = central_chunk
		central_chunk.y += 1
		has_moved_away = true
	elif player_position.y + PLAYER_PIXEL_SIZE / 2 < central_chunk_position_top:
		previous_central_chunk = central_chunk
		central_chunk.y -= 1
		has_moved_away = true

	return has_moved_away

func get_chunks_destroyed_blocks(position : Vector2) -> Array:
	if destroyed_blocks_by_chunk_position.has(position):
		return destroyed_blocks_by_chunk_position[position]
	return []

func update_chunks():
	DebugInfo.central_chunk = central_chunk
	var movement = central_chunk - previous_central_chunk
	
	self.position += movement * (4 * BLOCK_PIXEL_SIZE)
	for chunk in chunks:
		chunk.chunk_position.x += movement.x
		chunk.chunk_position.y += movement.y
		var destroyed_blocks = get_chunks_destroyed_blocks(chunk.chunk_position)
		chunk.update_blocks(destroyed_blocks)










