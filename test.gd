extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	return
	$Block.global_position = get_viewport().get_mouse_position()


func _on_Timer_timeout():
	
	$Block.Destroy()
