# GLOBAL 
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	play_music()

func play_music():
	$AudioStreamPlayer.play()
