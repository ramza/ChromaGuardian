# PLAYER
extends KinematicBody2D

enum PLAYER_STATES {
	IDLE, RUN, SHOOT, HURT, JUMP, DEAD, FROZEN
}

var state = PLAYER_STATES.IDLE

var timer = 0.0

const WALK_FORCE = 300
const WALK_MAX_SPEED = 140
const STOP_FORCE = 1300
const JUMP_SPEED = 188
const KNOCKBACK_FORCE = 100

var velocity = Vector2()

onready var gravity = 5.5*ProjectSettings.get_setting("physics/2d/default_gravity")

onready var anim = get_node("AnimationPlayer")
onready var sprite = get_node("Sprite")
onready var collision = get_node("CollisionShape2D")
onready var gun_pos = get_node("gun_pos")

onready var audio = get_node("AudioStreamPlayer2D")
var bullet = preload("res://scenes/bullet.tscn")
var hurt_fx = preload("res://scenes/hurt_fx.tscn")

var face_right = true
var walk_left = false
var walk_right = false

var SHOOT_DELAY = 0.25
var hurt_time = 0.25

var health = 6
var GUI
var frozen = false

func _ready():
	GUI = get_tree().get_nodes_in_group("GUI")[0]

func _process(delta):
	walk_left = Input.is_action_pressed("move_left")
	walk_right = Input.is_action_pressed("move_right")
	
func change_state(new_state):
	state = new_state
	timer = 0.0
	
func flip():
	face_right = !face_right
	if face_right:
		gun_pos.position.x = 8
	else:
		gun_pos.position.x = -8
	
	sprite.transform.x *= -1
	
func _physics_process(delta):
	
	match(state):
		PLAYER_STATES.IDLE:
			idle(delta)
		PLAYER_STATES.RUN:
			run(delta)
		PLAYER_STATES.JUMP:
			jump(delta)
		PLAYER_STATES.HURT:
			hurt(delta)
		PLAYER_STATES.SHOOT:
			shoot(delta)
		PLAYER_STATES.DEAD:
			dead(delta)
		PLAYER_STATES.FROZEN:
			frozen(delta)
			
func frozen(delta):
	pass
	
func freeze():
	change_state(PLAYER_STATES.FROZEN)
	
func unfreeze():
	change_state(PLAYER_STATES.IDLE)

func idle(delta):
	move(delta)
	anim.play("idle")
	
	if Input.is_action_just_pressed("jump"):
		change_state(PLAYER_STATES.JUMP)
	elif Input.is_action_just_pressed("shoot"):
		change_state(PLAYER_STATES.SHOOT)
	elif walk_left or walk_right:
		change_state(PLAYER_STATES.RUN)

func run(delta):
	anim.play("run")
	move(delta)

	
	if Input.is_action_just_pressed("shoot"):
		change_state(PLAYER_STATES.SHOOT)
	elif Input.is_action_just_pressed("jump"):
		change_state(PLAYER_STATES.JUMP)
	elif walk_left:
		if face_right:
			flip()
	elif walk_right:
		if not face_right:
			flip()
	elif is_on_floor():
		change_state(PLAYER_STATES.IDLE)
	else:
		change_state(PLAYER_STATES.JUMP)
		

func jump(delta):
	move(delta)
	anim.play("jump")
	
	if Input.is_action_just_pressed("shoot"):
		change_state(PLAYER_STATES.SHOOT)
	elif walk_left:
		if face_right:
			flip()
	elif walk_right:
		if not face_right:
			flip()
			
	if is_on_floor():
		change_state(PLAYER_STATES.IDLE)
	
func shoot(delta):
	if timer == 0:
		var b = bullet.instance()
		b.position = gun_pos.global_position
		
		get_parent().add_child(b)
		
		if not face_right:
			b.flip()
		
	anim.play("shoot")
	timer += delta
	
	if timer > SHOOT_DELAY:
		if is_on_floor():
			change_state(PLAYER_STATES.IDLE)
		else:
			change_state(PLAYER_STATES.JUMP)
		
	elif not is_on_floor():
		# Vertical movement code. Apply gravity.
		velocity.y += gravity * delta

		# Move based on the velocity and snap to the ground.
		velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	else:
		velocity.x = 0
		
func dead(delta):
	anim.play("dead")
	apply_gravity(delta)

func apply_gravity(delta):
		
	# Vertical movement code. Apply gravity.
	velocity.y += gravity * delta

	# Move based on the velocity and snap to the ground.
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	
func take_damage(enemy):

	health -= enemy.damage
	GUI.health_control.animate_health(health)
	
	if health > 0:
		if enemy.global_position.x > global_position.x:
			if face_right:
				flip()
		elif not face_right:
			flip()
		
		var fx = hurt_fx.instance()
		get_parent().add_child(fx)
		fx.position = position
		change_state(PLAYER_STATES.HURT)
	else:
		change_state(PLAYER_STATES.DEAD)
	
func hurt(delta):
	anim.play("hurt")
	timer += delta
	if timer > hurt_time:
		change_state(PLAYER_STATES.IDLE)
	else:
		var walk = 1
		if not face_right:
			walk = -1
		# Vertical movement code. Apply gravity.
		velocity.x = walk * KNOCKBACK_FORCE
		velocity.y += gravity * delta
		# Move based on the velocity and snap to the ground.
		velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	
func move(delta):
	# Horizontal movement code. First, get the player's input.
	var walk = WALK_FORCE * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	# Slow down the player if they're not trying to move.
	if abs(walk) < WALK_FORCE * 0.2:
		# The velocity, slowed down a bit, and then reassigned.
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
	else:
		velocity.x += walk * delta
	# Clamp to the maximum horizontal movement speed.
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)
	
	# Vertical movement code. Apply gravity.
	velocity.y += gravity * delta

	# Move based on the velocity and snap to the ground.
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

	# Check for jumping. is_on_floor() must be called after movement code.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -JUMP_SPEED
		audio.play()
		change_state(PLAYER_STATES.JUMP)
