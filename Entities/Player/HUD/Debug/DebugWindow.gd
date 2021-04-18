extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)

func _process(delta):
	$PanelContainer/VBoxContainer/HBoxContainer/Health.text = str(PlayerInfo.health)
	$PanelContainer/VBoxContainer/HBoxContainer2/Fuel.text = str(PlayerInfo.fuel)
	$PanelContainer/VBoxContainer/HBoxContainer3/Money.text = str(PlayerInfo.money)
	$PanelContainer/VBoxContainer/HBoxContainer4/Speed.text = str(floor(DebugInfo.speed.x)) + " , " + str(floor(DebugInfo.speed.y))
	$PanelContainer/VBoxContainer/HBoxContainer5/ChunkCount.text = str(DebugInfo.spawned_chunks_count)
	$PanelContainer/VBoxContainer/HBoxContainer6/CentralChunk.text = str(DebugInfo.central_chunk)
	$PanelContainer/VBoxContainer/HBoxContainer7/PlayerPos.text = str(floor(PlayerInfo.position.x)) + " , " + str(floor(PlayerInfo.position.y))
	if (delta > 0):
		$PanelContainer/VBoxContainer/HBoxContainer8/FPS.text = str(Performance.get_monitor(Performance.TIME_FPS))
		
