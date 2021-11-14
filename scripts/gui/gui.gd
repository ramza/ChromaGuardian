# GUI
extends Control

onready var health_control = get_node("health_control")
onready var textbox = get_node("RichTextLabel")

func _ready():
	textbox.text = ""


