extends Node2D


const chunk = preload("res://world/chunk/Chunk.tscn")

func _ready():
	pass # Replace with function body.


func spawn_chunk(chunkPosition: Vector2):
	var chunk_instance = chunk.instance()
	chunk_instance.name = _get_chunk_name(chunkPosition)
	chunk_instance.init(chunkPosition)
	self.add_child(chunk_instance)

func despawn_chunk(chunkPosition: Vector2):
	get_node(_get_chunk_name(chunkPosition)).destroy()

func _get_chunk_name(chunkPosition: Vector2) -> String:
	return str(chunkPosition.x) + ";" + str(chunkPosition.y)
