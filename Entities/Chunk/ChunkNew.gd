extends Node2D

signal chunk_despawned

var block = preload("res://Entities/Block/BlockNew.tscn")
var chunk_position : Vector2

var destroyed_blocks : Array = []

const CHUNK_WIDTH : int = ChunkDefinition.CHUNK_WIDTH
const CHUNK_HEIGHT : int = ChunkDefinition.CHUNK_HEIGHT
const BLOCK_SIZE : int = ChunkDefinition.BLOCK_SIZE

func init(var chunk_position : Vector2, var destroyed_blocks : Array):
	self.chunk_position = chunk_position
	self.destroyed_blocks = destroyed_blocks

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn()

func spawn():
	for x in CHUNK_WIDTH:
		for y in CHUNK_HEIGHT:
			if block_was_destroyed(x,y):
				continue
			var block_instance = block.instance()
			block_instance.init(chunk_position, Vector2(x , y))
			block_instance.position = Vector2(BLOCK_SIZE * x, BLOCK_SIZE * y)
			block_instance.name = (get_block_name(x,y))
			block_instance.connect("destroyed", self, "handle_block_destroyed")
			# TODO: Assign texture by blocks depth
			self.add_child(block_instance)

func block_was_destroyed(x : int,y : int) -> bool:
	return destroyed_blocks.has(Vector2(x,y))

func get_block_name(x : int, y : int) -> String:
	return str(x) + "-" + str(y)

func get_destroyed_blocks() -> Array:
	return destroyed_blocks

func handle_block_destroyed(block_position : Vector2):
	destroyed_blocks.append(block_position)
	print("Destroyed block " + str(block_position))
