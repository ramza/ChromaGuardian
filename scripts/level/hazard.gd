# HAZARD
extends Node2D

onready var area2d = get_node("Area2D")
var spawn_pos
var player
var timer

func _ready():
	spawn_pos = $"player_spawn".global_position
	timer = $"Timer"
	area2d.connect("body_entered",self,"_on_hazard_body_entered")
	timer.connect("timeout",self,"_on_hazard_timer_timeout")

func _on_hazard_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player.freeze()
		timer.start()
		
func _on_hazard_timer_timeout():
	player.global_position = spawn_pos
	timer.stop()
	player.unfreeze()
