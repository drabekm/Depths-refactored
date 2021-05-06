extends StaticBody2D

signal destroyed

var corner_status : int = 0
var parent_chunk_position : Vector2
var destroyed : bool = false
export var position_in_parent_chunk : Vector2

var colision_shape : CollisionShape2D
var sprites : Array

func init(var parent_position, var block_position):
	parent_chunk_position = parent_position
	position_in_parent_chunk = block_position

func _ready():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	
	sprites = get_node("Sprites").get_children()
	colision_shape = get_node("CollisionShape2D")

func respawn():
	colision_shape.disabled = false
	show_sprites()
	destroyed = false

func destroy(destroyed_by_player : bool):
	if destroyed_by_player:
		emit_signal("destroyed", position_in_parent_chunk)
	colision_shape.disabled = true
	hide_sprites()
	destroyed = true

func update_corner_sprites(var corner_status = 0):
	if corner_status == 0:
		get_node("Sprites/Base").texture = load("res://Entities/Block/Sprites/test/source/base.png")
	
	if corner_status & CornerStates.TOP_MISSING:
		get_node("Sprites/Base").texture = load("res://Entities/Block/Sprites/test/source/topwall2.png")

func hide_sprites():
	for sprite in sprites:
		sprite.visible = false

func show_sprites():
	for sprite in sprites:
		sprite.visible = true
