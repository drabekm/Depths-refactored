extends StaticBody2D

signal destroyed

var parent_chunk_position : Vector2
var position_in_parent_chunk : Vector2

func init(var parent_position, var block_position):
	parent_chunk_position = parent_position
	position_in_parent_chunk = block_position

func _ready():
	pass # Replace with function body.

func destroy():
	emit_signal("destroyed", position_in_parent_chunk)
	queue_free()
