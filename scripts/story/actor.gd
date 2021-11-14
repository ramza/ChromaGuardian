# ACTOR
extends KinematicBody2D

enum ACTOR_STATES {
	IDLE, RUN, SHOOT, HURT, JUMP,
}

var state = ACTOR_STATES.IDLE

var timer = 0.0

const WALK_FORCE = 100

onready var anim = get_node("AnimationPlayer")

var direction = Vector2.RIGHT
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func change_state(new_state):
	state = new_state
	timer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match(state):
		ACTOR_STATES.IDLE:
			idle()
		ACTOR_STATES.RUN:
			run(delta)
	
func run(delta):
	anim.play("run")
	# Vertical movement code. Apply gravity.
	velocity += direction * WALK_FORCE * delta

	# Move based on the velocity and snap to the ground.
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	
	
func idle():
	anim.play("idle")
