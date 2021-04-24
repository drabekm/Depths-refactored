extends Node

const CHUNK_WIDTH = 4
const CHUNK_HEIGHT = 4
const BLOCK_PIXEL_SIZE = 32
const CHUNK_PIXEL_SIZE = CHUNK_WIDTH * BLOCK_PIXEL_SIZE

func _ready():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
