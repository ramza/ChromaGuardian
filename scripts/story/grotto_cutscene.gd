# GROTTO CUTSCENE
extends Node2D

var state = 0

var timer = 0

onready var guardian = get_node("guardian")

onready var door = get_node("door")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		0:
			start(delta)
		1:
			door(delta)
		2:
			walk(delta)
			
func start(delta):
	timer += delta
	if timer > 3:
		timer = 0
		$Rainbow.hide()
		state = 1
		
func door(delta):
	timer += delta
	if timer > 3:
		door.get_node("AnimationPlayer").play("open")
		timer = 0
		state = 2
		guardian.change_state(guardian.ACTOR_STATES.RUN)
		
func walk(delta):
	timer += delta
	if timer > 3:
		get_tree().change_scene("res://Scenes/grotto.tscn")
