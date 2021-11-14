# BULLET
extends KinematicBody2D

var velocity = Vector2.RIGHT
var direction = Vector2.RIGHT
var SPEED = 300

onready var area2d = get_node("Area2D")
onready var sprite = get_node("Sprite")

# Called when the node enters the scene tree for the first time.
func _ready():
	area2d.connect("body_entered", self, "_on_bullet_body_entered")
	area2d.connect("area_entered", self, "_on_bullet_area_entered")

func flip():
	direction = Vector2.LEFT
	sprite.transform.x *= -1
	
func _on_bullet_area_entered(area):
	if area.get_parent().is_in_group("enemy"):
		area.get_parent().destroy()
		queue_free()

func _on_bullet_body_entered(body):
	if body.is_in_group("player"):
		pass
	elif body == self:
		pass
	else:
		queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.x = direction.x * SPEED

	# Move based on the velocity and snap to the ground.
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	
	

