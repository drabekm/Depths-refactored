extends StaticBody2D

signal destroyed

var parent_chunk_position : Vector2
var destroyed : bool = false
export var position_in_parent_chunk : Vector2

var colision_shape : CollisionShape2D
var sprite : Sprite

func init(var parent_position, var block_position):
	parent_chunk_position = parent_position
	position_in_parent_chunk = block_position

func _ready():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	
	sprite = get_node("Sprite")
	colision_shape = get_node("CollisionShape2D")

func respawn():
	colision_shape.disabled = false
	sprite.visible = true
	destroyed = false

func destroy(destroyed_by_player : bool):
	if destroyed_by_player:
		emit_signal("destroyed", position_in_parent_chunk)
	colision_shape.disabled = true
	sprite.visible = false
	destroyed = true
