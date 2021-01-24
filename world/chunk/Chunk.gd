extends Node2D

var block = preload("res://world/block/Block.tscn")

var chunk_index : Vector2

const CHUNK_WIDTH = 30
const CHUNK_HEIGHT = 10
const BLOCK_SIZE = 32

var deleted_blocks = {}
var blocks_corner_state = {}

func _ready():
	pass # Replace with function body.

func init(chunk_position : Vector2, deleted_blocks : Dictionary, corner_states : Dictionary):
	self.deleted_blocks = deleted_blocks
	self.blocks_corner_state = corner_states
	
	spawn_blocks(chunk_position)

func destroy():
	self.queue_free()

func _create_block(position: Vector2, block_index: Vector2) -> StaticBody2D:
	var block_instance = block.instance()
	block_instance.position = position
	var corner_state = 0
	if(blocks_corner_state.has(block_index)):
		print("block_index")
		corner_state = blocks_corner_state[block_index]
	
	block_instance.init(0, 0, block_index, corner_state)
	block_instance.connect("on_destroyed", self, "_on_block_destroyed_handler")
	block_instance.connect("on_corner_state_updated", self, "_on_corner_state_updated_handler")
	
	return block_instance

func get_deleted_blocks() -> Dictionary:
	return deleted_blocks

func get_corner_states() -> Dictionary:
	return blocks_corner_state

func _on_block_destroyed_handler(block_index):
	deleted_blocks[block_index] = true

func _on_corner_state_updated_handler(block_index, corner_state):
	blocks_corner_state[block_index] = corner_state

func _is_block_destroyed(block_index: Vector2) -> bool:
	return deleted_blocks.has(block_index) and deleted_blocks[block_index]

func spawn_blocks(chunkPosition : Vector2):
	for i in range(CHUNK_WIDTH):
		for j in range(CHUNK_HEIGHT):
			
			if _is_block_destroyed(Vector2(i,j)):
				print("block_is_destroyed")
				continue
			
			var chunk_offset_x = chunkPosition.x * CHUNK_WIDTH * BLOCK_SIZE
			var chunk_offset_y = chunkPosition.y * CHUNK_HEIGHT * BLOCK_SIZE
			var block_position = Vector2(chunk_offset_x + BLOCK_SIZE * i, chunk_offset_y + BLOCK_SIZE * j)
			var block_instance = _create_block(block_position, Vector2(i,j))
			self.add_child(block_instance)

func _get_block_name(blockPosition: Vector2) -> String:
	return str(blockPosition.x) + ";" + str(blockPosition.y)
