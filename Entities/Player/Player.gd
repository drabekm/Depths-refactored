extends KinematicBody2D

const GRAVITY_ACC = 7
const FLOOR_NORMAL = Vector2(0, -1)

var speed : Vector2 = Vector2(0.0, 0.0)
var direction : Vector2 = Vector2(0,0)

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_process_input()
	



func _process_input():
	if Input.is_action_pressed("ui_left"):
		direction.x = -1 
	elif Input.is_action_pressed("ui_right"):
		direction.x = 1
	else:
		direction.x = 0
	
	PlayerInfo.is_rocket_on = Input.is_action_pressed("ui_up")
	

func _process_horizontal_movement() -> void:
	if direction.x > 0: # right movement
		speed.x = min(speed.x + PlayerInfo.acceleration, PlayerInfo.max_speed)
	elif direction.x < 0:
		speed.x = max(speed.x - PlayerInfo.acceleration, -PlayerInfo.max_speed)
	else:
		speed.x = lerp(speed.x, 0, 0.25)

func _process_vertical_movement() -> void:
	if self.is_on_floor():
		speed.y = 0
	else:
		speed.y += GRAVITY_ACC 
	
	if PlayerInfo.is_rocket_on:
		speed.y -= PlayerInfo.rocket_power 

func _physics_process(delta):
	_process_horizontal_movement()
	_process_vertical_movement()
	speed = move_and_slide(speed, FLOOR_NORMAL)
