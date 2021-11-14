extends KinematicBody2D
# CAMERA CODE


export var followX = true
export var followY = false
export var minX = 0
export var maxX = 1000
export var maxY = 320
export var minY = -1000
var speed = 16000
var direction = 1
var player
var velocity = Vector2.ZERO
var startPosition = Vector2.ZERO

onready var area2d = get_node("BorderBoxes")
# Called when the node enters the scene tree for the first time.

func ResetPosition():
	position = player.position + Vector2.UP*100 + Vector2.RIGHT*-160

func _ready():
	area2d.connect("area_entered", self, "OnAreaEntered")
	var players = get_tree().get_nodes_in_group("player")
	player = players[0]


func OnAreaEntered(area):
	if !area.get_owner():
		return
	
	if area.get_owner().is_in_group("Sparkles") or area.get_owner().is_in_group("Bubbles") or area.get_owner().is_in_group("Radiant"):
		#print("kill magic")
		area.get_owner().queue_free()
		
func _physics_process(delta):
	# Move along the x axis.
	if followX and player.global_position.x - (global_position.x+100) > 60:
		velocity.x = speed * direction * delta
		move_and_slide_with_snap(velocity, Vector2(0,-1))
	elif followX and player.global_position.x - (global_position.x+60) < 80:
		velocity.x = speed * -direction * delta
		move_and_slide_with_snap(velocity,  Vector2(0,-1))
	else:
		velocity.x = 0
		
	#Move along the y axis.
	if followY and player.global_position.y - (global_position.y+100) > 10:
		velocity.y = speed * direction * delta
		move_and_slide_with_snap(velocity, Vector2(0,-1))
	elif followY and player.global_position.y - (global_position.y+60) < 10:
		velocity.y = speed * -direction * delta
		move_and_slide_with_snap(velocity,  Vector2(0,-1))
	else:
		velocity.y = 0
		
		
	if global_position.x < minX:
		global_position.x = minX
	elif global_position.x > maxX:
		global_position.x = maxX
		
	if global_position.y > maxY:
		global_position.y = maxY
	elif global_position.y < minY:
		global_position.y = minY
		
		
	
