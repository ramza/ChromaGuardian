# HURT FX
extends Node2D

onready var timer = get_node("Timer")

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.connect("timeout",self,"_on_timer_timeout")
	pass # Replace with function body.

func _on_timer_timeout():
	queue_free()

