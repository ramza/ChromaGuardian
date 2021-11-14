# HEALTH CONTROL
extends Control


onready var anim = get_node("AnimationPlayer")

func animate_health(health):
	match(health):
		0:
			anim.play("0")
		1:
			anim.play("1")
		2:
			anim.play("2")
		3:
			anim.play("3")
		4:
			anim.play("4")
		5:
			anim.play("5")
		6:
			anim.play("6")
