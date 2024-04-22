extends CharacterBody2D

# Unit Selection
var mouseEntered = false
@export var selected = false

@onready var box = get_node("Box")
@onready var movementTarget = position
@onready var animation = get_node("AnimationPlayer")

# Unit Owner
@export var unitOwner := 0

# Unit Movement
var followCursor = false
var speed = 100
const move_threshold = 100 #How much closer to the target
var lastDistanceToTarget = Vector2.ZERO
var currentDistanceToTarget = Vector2.ZERO
@onready var stopTimer = $StopTimer


func _ready():
	setSelected(selected)
	add_to_group("meleeAttackers", true)
	
	# Sets the enemy units to red
	if unitOwner == 1:
		modulate = Color(1, 0.29, 0.165,1)
	

func setSelected(value): 
	box.visible = value
	selected = value
	

# Handles input
func _input(event):
	if event.is_action_pressed("LeftClick"):
		if mouseEntered:
			setSelected(!selected)
	
	if(event.is_action_pressed("RightClick")):
		#var MinimapPath = get_tree().get_root().get_node("World/UI/MiniMap/SubViewportContainer/SubViewport")
		#MinimapPath._ready()
		followCursor = true
	
	if(event.is_action_released("RightClick")):
		followCursor = false
	pass


func moveToTarget(delta, target):
	if followCursor:
		if selected:
			movementTarget = get_global_mouse_position()
			
	velocity = position.direction_to(movementTarget) * speed
	
	move_and_slide()
	#if velocity.x > 10:
		#animation.play("WalkRight")
	#elif velocity.x < -10:
		#animation.play("WalkLeft")
	#elif velocity.y < 0:
		#animation.play("WalkUp")
	#else:
		#animation.play("WalkDown")

	if get_slide_collision_count() and stopTimer.is_stopped():
		stopTimer.start()
		lastDistanceToTarget = position.distance_to(movementTarget)


func _on_meleeAttacker_mouse_entered():
	mouseEntered = true


func _on_meleeAttacker_mouse_exited():
	mouseEntered = false
