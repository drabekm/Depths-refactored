extends StaticBody2D

var parent_chunk_position : Vector2
var position_in_parent_chunk : Vector2

func init(var parent_position, var block_position):
	parent_chunk_position = parent_position
	position_in_parent_chunk = block_position

func _ready():
	pass # Replace with function body.
