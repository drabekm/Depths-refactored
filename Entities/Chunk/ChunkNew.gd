extends Node2D

var block = preload("res://Entities/Block/BlockNew.tscn")
var chunk_position : Vector2

const CHUNK_WIDTH : int = ChunkDefinition.CHUNK_WIDTH
const CHUNK_HEIGHT : int = ChunkDefinition.CHUNK_HEIGHT
const BLOCK_SIZE : int = ChunkDefinition.BLOCK_SIZE

func init(var chunk_position : Vector2):
	self.chunk_position = chunk_position

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn()

func spawn():
	for x in CHUNK_WIDTH:
		for y in CHUNK_HEIGHT:
			if x == 1 || y == 5:
				continue
			var block_instance = block.instance()
			block_instance.init(chunk_position, Vector2(x , y))
			block_instance.position = Vector2(BLOCK_SIZE * x, BLOCK_SIZE * y)
			block_instance.name = (get_block_name(x,y))
			# TODO: Assign texture by blocks depth
			self.add_child(block_instance)

func get_block_name(x : int, y : int) -> String:
	return str(x) + "-" + str(y)

func despawn():
	pass
