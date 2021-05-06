extends Node2D

signal block_destroyed
export var chunk_position : Vector2

var destroyed_blocks : Array = []
var blocks = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	get_blocks()

func _process(delta):
	$Label.text = str(chunk_position)

func get_blocks():
	var children = get_children()
	for child in children:
		if child.name != 'Label':
			child.connect("destroyed", self, "block_destroyed_handler")
			blocks[child.position_in_parent_chunk] = child

func block_destroyed_handler(block_position : Vector2):
	emit_signal("block_destroyed", block_position, chunk_position)

func block_was_destroyed(x : int,y : int) -> bool:
	return destroyed_blocks.has(Vector2(x,y))

func get_destroyed_blocks() -> Array:
	return destroyed_blocks

func update_block_corner(var block_position: Vector2, var corner_value) -> void:
	blocks[block_position].update_corner_sprites(corner_value)
 
func update_blocks(destroyed_blocks : Array, block_statuses : Dictionary):
	for block in blocks.values():
		if chunk_position.y < 0:
			block.destroy(false)
		else:
			block.respawn()
			if block_statuses.has(block.position_in_parent_chunk):
				block.update_corner_sprites(block_statuses[block.position_in_parent_chunk])
			else:
				block.update_corner_sprites()
	
	if chunk_position.y >= 0:
		for destroyed_block_position in destroyed_blocks:
			var block = blocks[destroyed_block_position]
			block.destroy(false)

func handle_block_destroyed(block_position : Vector2):
	destroyed_blocks.append(block_position)
