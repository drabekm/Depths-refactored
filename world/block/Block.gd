extends StaticBody2D

const SPRITE_SIZE = 32

var type : int
var ore_type : int
var corner_state : int
var detectors_on : bool = false

var indestructable : bool

var position_index : Vector2

var neighbour_detectors = []
var diagonal_neigbour_detectors = []

signal on_destroyed
signal on_corner_state_updated

func _ready():
	corner_state = 0 #TODO: Remove this when the init function is used
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	_loadNeighbourDetectors()
#
	if ProjectSettings.get_setting("debug/settings/allow_debug_scripts"):
		self.input_pickable = true
	
	#TODO: add indestructible check
	

func _loadNeighbourDetectors() -> void:
	neighbour_detectors = get_node("NeighbourDetectors").get_children()
	for detector in neighbour_detectors:
		detector.add_exception(self)
		if detector.is_in_group("DiagonalDetector"):
			var diagonal_collider = get_node("ColliderForDiagonalNeigbours")
			detector.add_exception(diagonal_collider)
			diagonal_neigbour_detectors.append(detector)

func _enable_neigbour_detectors() -> void:
	for detector in neighbour_detectors:
		detector.enabled = true
		detector.force_raycast_update()

func _disable_neigbour_detectors() -> void:
	for detector in neighbour_detectors:
		detector.enabled = false

func _set_sprite_by_corner_state() -> bool:
	var new_texture = load("res://world/block/textures/debug/" + str(corner_state) + ".png")
	
	if new_texture != null:
		get_node("BlockSprite").texture = new_texture
		return true
	
	return false


func init(type: int, ore_type:int, position_index: Vector2, corner_state : int = 0):
	self.type = type
	self.ore_type = ore_type
	self.position_index = position_index	
	#TODO: add ore sprite loading
	self.corner_state = corner_state
	
	_set_sprite_by_corner_state()


func Destroy() -> void:
	emit_signal("on_destroyed", self.position_index)
	if not detectors_on:
		_enable_neigbour_detectors()
	
	for detector in neighbour_detectors:
		if detector.is_colliding():
			var colider = detector.get_collider()
			
			if colider.is_in_group("Block"):
				colider.UpdateCornerStatus(self.global_position)
			elif colider.is_in_group("BlockHelperCollider"):
				colider.get_parent().UpdateCornerStatus(self.global_position)
	
	self.queue_free()

#Podle rozdílu souřadnic se určuje ze které strany zmizel sousední blok
#a podle toho se určuje nová odpovídající textura
func UpdateCornerStatus(neigbour_global_position):
	var is_x_coord_differing = self.global_position.x != neigbour_global_position.x
	var is_neigbour_left = (self.global_position.x - neigbour_global_position.x) > 0
	
	var is_y_coord_differing = self.global_position.y != neigbour_global_position.y
	var is_neigbour_top = (self.global_position.y - neigbour_global_position.y) > 0
	
	var distance = self.global_position.distance_to(neigbour_global_position)
	var is_neigbour_diagonal = distance > SPRITE_SIZE
	
	if is_x_coord_differing and not is_neigbour_diagonal:
		if is_neigbour_left:
			corner_state = corner_state | 1
		else:
			corner_state = corner_state | 2
	
	if is_y_coord_differing and not is_neigbour_diagonal:
		if is_neigbour_top:
			corner_state = corner_state | 4
		else:
			corner_state = corner_state | 8
	
	if is_neigbour_diagonal:
		if is_neigbour_left and is_neigbour_top:
			corner_state = corner_state | 16
		elif not is_neigbour_left and is_neigbour_top:
			corner_state = corner_state | 32
		elif not is_neigbour_left and not is_neigbour_top:
			corner_state = corner_state | 64
		elif is_neigbour_left and not is_neigbour_top:
			corner_state = corner_state | 128
	emit_signal("on_corner_state_updated", self.position_index, corner_state)
	_set_sprite_by_corner_state()


func _on_Block_mouse_entered():
	print("mouse event")
	Destroy()
