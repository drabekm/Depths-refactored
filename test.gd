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


func _on_Timer_timeout():
	
	$BlockSpriteUpdate/Block.Destroy()


func _on_Button_pressed():
	$ChunkHandler.spawn_chunk(Vector2(0,0))
#	$ChunkHandler.spawn_chunk(Vector2(0,-1))


func _on_Button2_pressed():
	$ChunkHandler.despawn_chunk(Vector2(0,0))
#	$ChunkHandler.despawn_chunk(Vector2(0,-1))
