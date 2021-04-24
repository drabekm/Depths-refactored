extends Node2D

signal block_destroyed
export var chunk_position : Vector2

var destroyed_blocks : Array = []
var blocks = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	get_blocks()

func get_blocks():
	var children = get_children()
	for child in children:
		child.connect("destroyed", self, "block_destroyed_handler")
		blocks[child.position_in_parent_chunk] = child

func block_destroyed_handler(block_position : Vector2):
	emit_signal("block_destroyed", block_position, chunk_position)

func block_was_destroyed(x : int,y : int) -> bool:
	return destroyed_blocks.has(Vector2(x,y))

func get_destroyed_blocks() -> Array:
	return destroyed_blocks

func update_blocks(destroyed_blocks : Array):
	for block in blocks.values():
		if chunk_position.y < 0:
			block.destroy(false)
		else:
			block.respawn()
	
	if chunk_position.y >= 0:
		for destroyed_block_position in destroyed_blocks:
			var block = blocks[destroyed_block_position]
			block.destroy(false)

func handle_block_destroyed(block_position : Vector2):
	destroyed_blocks.append(block_position)
