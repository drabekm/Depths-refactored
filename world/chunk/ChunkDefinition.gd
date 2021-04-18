extends Node

const CHUNK_WIDTH = 5
const CHUNK_HEIGHT = 5
const BLOCK_SIZE = 32

func _ready():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
