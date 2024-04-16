extends CharacterBody2D

@export var selected = false
@onready var box = get_node("Box")
@onready var target = position
@onready var animation = get_node("AnimationPlayer")

var followCursor = false
var speed = 50


func _ready():
	setSelected(selected)
	

func setSelected(value): 
	box.visible = value
	selected = value
	

# Handles input
func _input(event):
	if(event.is_action_pressed("RightClick")):
		followCursor = true
	
	if(event.is_action_released("RightClick")):
		followCursor = false
	pass

# Handles the click and move
func _physics_process(delta):
	if followCursor:
		if selected:
			target = get_global_mouse_position()
			animation.play("WalkDown")
	
	velocity = position.direction_to(target) * speed
	
	if position.distance_to(target) > 20:
		move_and_slide()
	else:
		animation.stop()
	

