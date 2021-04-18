extends Control

var quit_pressed: bool = false

var fader: Control

func _ready():
	$MarginContainer/VBoxContainer/ButtonMargins/Buttons/NewGame.grab_focus()
	fader = get_node("Fader")
	fader.fade_in()

func _on_Quit_pressed():
	quit_pressed = true
	fader.fade_out()

func _on_Fader_fade_out_finished():
	if quit_pressed:
		get_tree().quit(0)
