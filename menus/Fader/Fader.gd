extends Control

signal fade_out_finished
signal fade_in_finished
signal fading_started

var fade_in_name = "FadeIn"
var fade_out_name = "FadeOut"

func _ready():
	pass

func fade_out():
	emit_signal("fading_started")
	$AnimationPlayer.play(fade_out_name)

func fade_in():
	emit_signal("fading_started")
	$AnimationPlayer.play(fade_in_name)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == fade_in_name:
		emit_signal("fade_in_finished")
	elif anim_name == fade_out_name:
		emit_signal("fade_out_finished")
