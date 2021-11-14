# SLIME
extends KinematicBody2D

enum SLIME_STATES {
	IDLE, WALK
}

var state = SLIME_STATES.IDLE

var SPEED = 60
var timer = 0.0
var face_right = true

var walk_time = 1
var idle_time = 2
var damage = 1
var direction = Vector2.RIGHT
var velocity = Vector2.RIGHT

var explosion = preload("res://scenes/green_flames.tscn")
onready var gravity = 5.5*ProjectSettings.get_setting("physics/2d/default_gravity")

onready var anim = get_node("AnimationPlayer")
onready var sprite = get_node("Sprite")
onready var area2d = get_node("Area2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	area2d.connect("body_entered", self, "_on_slime_body_entered")
	pass # Replace with function body.

func _on_slime_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(self)
		
func change_state(new_state):
	state = new_state
	timer = 0.0
	
func flip():
	face_right = !face_right
	sprite.transform.x *= -1
	

func destroy():
	var e = explosion.instance()
	get_parent().add_child(e)
	e.position = position
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match(state):
		SLIME_STATES.IDLE:
			idle(delta)
		SLIME_STATES.WALK:
			walk(delta)
			
func idle(delta):
	anim.play("idle")
	timer += delta
	if timer > idle_time:
		flip()
		change_state(SLIME_STATES.WALK)

func walk(delta):
	anim.play("walk")
	timer += delta
	if timer > walk_time:
		change_state(SLIME_STATES.IDLE)
		velocity = Vector2.ZERO
		return
		
	if face_right:
		direction.x = 1
	else:
		direction.x = -1
		
	var force = direction*SPEED
	
	# Integrate forces to velocity
	velocity += force * delta
	# Integrate velocity into motion and move
	velocity = move_and_slide(velocity, Vector2(0, -1))
