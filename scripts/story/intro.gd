# INTRO
extends Node2D

var dialogue = [
	"After what felt like an endless sleep, the Chroma Guardians have awoken.",
	"Something disturbs the delicate balance of light and dark.",
	"This contrast defines reality.",
	"Darkness seeks to overwhelm the light.",
	"At the darkest hour, the Chroma Guardians return to defend light.",
]

onready var text_box = get_node("RichTextLabel")
onready var timer = get_node("Timer")

var dialogue_index = 0
var end_flag = false

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.connect("timeout",self,"_on_timer_timeout")
	text_box.text = dialogue[0]
	$rainbow.hide()
	
func _on_timer_timeout():
	if end_flag:
		get_tree().change_scene("res://scenes/grotto_cutscene.tscn")
		
	dialogue_index += 1
	if dialogue_index >= len(dialogue):
		$rainbow.show()
		text_box.hide()
		timer.wait_time = 3
		end_flag = true
		return
	text_box.text = dialogue[dialogue_index]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
