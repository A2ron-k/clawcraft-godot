extends CharacterBody2D

# Unit Selection
var mouseEntered = false
@export var selected = false

@onready var box = get_node("Box")
@onready var target = position
@onready var animation = get_node("AnimationPlayer")

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

# Handles the click and move
func _physics_process(delta):
	if followCursor:
		if selected:
			target = get_global_mouse_position()
	
	velocity = position.direction_to(target) * speed
	
	if position.distance_to(target) > 15:
		move_and_slide()
		if velocity.x > 10:
			animation.play("WalkRight")
		elif velocity.x < -10:
			animation.play("WalkLeft")
		elif velocity.y < 0:
			animation.play("WalkUp")
		else:
			animation.play("WalkDown")
	else:
		animation.stop()

	if get_slide_collision_count() and stopTimer.is_stopped():
		stopTimer.start()
		lastDistanceToTarget = position.distance_to(target) 

func _on_meleeAttacker_mouse_entered():
	mouseEntered = true


func _on_meleeAttacker_mouse_exited():
	mouseEntered = false


func _on_stop_timer_timeout():
	if get_slide_collision_count():
		currentDistanceToTarget = position.distance_to(target)
		if lastDistanceToTarget < currentDistanceToTarget + move_threshold:
			target = position
			animation.stop()
