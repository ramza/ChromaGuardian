# EXPLOSION
extends Node2D

onready var anim = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.connect("animation_finished", self, "_on_anim_finished")
	pass # Replace with function body.


func _on_anim_finished(animation):
	queue_free()

