extends Node2D

var block = preload("res://world/block/Block.tscn")

const CHUNK_WIDTH = 30
const CHUNK_HEIGHT = 10
const BLOCK_SIZE = 32

var deleted_blocks = {Vector2(0,0): true}

func _ready():
	pass # Replace with function body.

func init(chunkPosition : Vector2):
	spawn_blocks(chunkPosition)

func destroy():
	self.queue_free()

func _create_block(position: Vector2, block_index: Vector2) -> StaticBody2D:
	var block_instance = block.instance()
	block_instance.position = position
	block_instance.init(0, 0, block_index, 0)
	block_instance.connect("destroyed", self, "_block_destroyed_handler")
	
	return block_instance

func _block_destroyed_handler(block_index):
	deleted_blocks[block_index] = true

func _is_block_destroyed(block_index: Vector2) -> bool:
	return deleted_blocks.has(block_index) and deleted_blocks[block_index]

func spawn_blocks(chunkPosition : Vector2):
	for i in range(CHUNK_WIDTH):
		for j in range(CHUNK_HEIGHT):
			
			if _is_block_destroyed(Vector2(i,j)):
				continue
			
			var chunk_offset_x = chunkPosition.x * CHUNK_WIDTH * BLOCK_SIZE
			var chunk_offset_y = chunkPosition.y * CHUNK_HEIGHT * BLOCK_SIZE
			var block_position = Vector2(chunk_offset_x + BLOCK_SIZE * i, chunk_offset_y + BLOCK_SIZE * j)
			var block_instance = _create_block(block_position, Vector2(i,j))
			self.add_child(block_instance)


func _get_block_name(blockPosition: Vector2) -> String:
	return str(blockPosition.x) + ";" + str(blockPosition.y)
