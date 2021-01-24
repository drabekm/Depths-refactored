extends Node2D


const chunk = preload("res://world/chunk/Chunk.tscn")

var chunk_deleted_blocks = {}
var chunk_corner_states = {}

func _ready():
	pass # Replace with function body.


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
	self.add_child(chunk_instance)

func despawn_chunk(chunk_position: Vector2):
	var chunk = get_node(_get_chunk_name(chunk_position))
	
	chunk_deleted_blocks[chunk_position] = chunk.get_deleted_blocks()
	chunk_corner_states[chunk_position] = chunk.get_corner_states()
	
	chunk.destroy()

func _get_chunk_name(chunk_position: Vector2) -> String:
	return str(chunk_position.x) + ";" + str(chunk_position.y)
