# EXTRA HEART
extends Node2D

onready var area2d = get_node("Area2D")

var GUI

# Called when the node enters the scene tree for the first time.
func _ready():
	area2d.connect("body_entered",self,"_on_body_entered")
	GUI = get_tree().get_nodes_in_group("GUI")[0]
	
func _on_body_entered(body):
	if body.name == "player":
		body.health += 1
		if body.health > 6:
			body.health = 6
		GUI.health_control.animate_health(body.health)
		self.queue_free()
