extends StaticBody2D

const SPRITE_SIZE = 32

var type : int
var corner_state : int


var neighbour_detectors = []
var diagonal_neigbour_detectors = []

signal destroyed

func _ready():
	_loadNeighbourDetectors()
	

func _loadNeighbourDetectors() -> void:
	neighbour_detectors = get_node("NeighbourDetectors").get_children()
	for detector in neighbour_detectors:
		detector.add_exception(self)
		if detector.is_in_group("DiagonalDetector"):
			diagonal_neigbour_detectors.append(detector)
	
	

func init(type: int, corner_state : int = 0):
	self.type = type
	self.corner_state = 0


func Destroy() -> void:
	for detector in neighbour_detectors:
		if detector.is_colliding():
			
			var colider = detector.get_collider()
			
			#Když je blok co je našikmo od současnýho bloku obklopen ostatnímy bloky
			#raycasty to ne vždycky správně detekují. Proto se bloky detekovaný vodorovnýma
			#a vertikálníma raycastama přidávají jako vyjímky pro šikmý raycasty
			if detector.is_in_group("NonDiagonalDetector"):
				for diagonal_detector in diagonal_neigbour_detectors:
					diagonal_detector.add_exception(colider)
			
			if colider.is_in_group("Block"):
				colider.UpdateCornerStatus(self.global_position)
	
	#TODO: Uncoment this, eventually
	#self.queue_free()

#Podle rozdílu souřadnic se určuje ze které strany zmizel sousední blok
#a podle toho se určuje nová odpovídající textura
func UpdateCornerStatus(neigbour_global_position):
	var is_x_coord_differing = self.global_position.x != neigbour_global_position.x
	var is_neigbour_left = (self.global_position.x - neigbour_global_position.x) < 0
	
	var is_y_coord_differing = self.global_position.y != neigbour_global_position.y
	var is_neigbour_top = (self.global_position.y - neigbour_global_position.y) < 0
	
	var distance = self.global_position.distance_to(neigbour_global_position)
	var is_neigbour_diagonal = distance > SPRITE_SIZE
	
	if is_x_coord_differing:
		if is_neigbour_left:
			corner_state = corner_state | 1
		else:
			corner_state = corner_state | 2
	
	if is_y_coord_differing:
		if is_neigbour_top:
			corner_state = corner_state | 4
		else:
			corner_state = corner_state | 8
	
	if is_neigbour_diagonal:
		corner_state = corner_state | 16
	
	# TODO: put texture updating method here


func _process(delta):
	return
