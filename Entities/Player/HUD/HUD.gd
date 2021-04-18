extends CanvasLayer


var debug_window : Control
func _ready():
	debug_window = get_node("DebugWindow")
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("show_debug"):
		debug_window.visible = !debug_window.visible

