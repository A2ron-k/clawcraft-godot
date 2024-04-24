extends CharacterBody2D
class_name Gatherer

# Children
@onready var box = get_node("Box")
@onready var movementTarget = position
@onready var animation = get_node("AnimationPlayer")
@onready var collisionShape = get_node("CollisionShape2D")
@onready var stateMachine = get_node("gathererStateMachine")
@onready var navAgent = get_node("NavigationNode/NavigationAgent2D")

# Unit Owner
@export var unitOwner := 0

# Unit Selection
var mouseEntered = false
@export var selected = false

# Unit Movement
var followCursor = false
var speed = 30
const move_threshold = 100 #How much closer to the target
var lastDistanceToTarget = Vector2.ZERO
var currentDistanceToTarget = Vector2.ZERO
@onready var stopTimer = $StopTimer

## Unit Navigation/ Pathfinding
var navTarget

# Unit Stats
var health = 4
var gatherRange = 20

# Unit Logic
var possibleTargets = []
var gatherTarget = null
@export var noOfCatnipCarrying = 0
@onready var homeBasePosition = get_tree().get_root().get_node("World/HomeBase/Base").position



# Called when the node enters the scene tree for the first time.
func _ready():
	setSelected(selected)
	add_to_group("units", true)
	add_to_group("gatherers", true)
	
	# Sets the enemy units to red
	if unitOwner == 1:
		modulate = Color(1, 0.29, 0.165,1)


# Toggle unit selection and selection marker
func setSelected(value): 
	box.visible = value
	selected = value


# Handles player input
func _input(event):
	if event.is_action_pressed("LeftClick"):
		if mouseEntered && unitOwner == 0:
			setSelected(!selected)
	
	if(event.is_action_pressed("RightClick")):
		#var MinimapPath = get_tree().get_root().get_node("World/UI/MiniMap/SubViewportContainer/SubViewport")
		#MinimapPath._ready()
		followCursor = true
	
	if(event.is_action_released("RightClick")):
		followCursor = false
	pass


# Handles unit movement to target
func moveToTarget(delta, target):
	var direction = Vector2.ZERO
	if followCursor:
		if selected:
			target = get_global_mouse_position()
	
	navTarget = target
	direction = navAgent.get_next_path_position() - position
	direction = direction.normalized()
	
	velocity = direction * speed
	
	move_and_slide()
	
	if get_slide_collision_count() and stopTimer.is_stopped():
		stopTimer.start()
		lastDistanceToTarget = position.distance_to(movementTarget)


func _on_gatherer_mouse_entered():
	mouseEntered = true


func _on_gatherer_mouse_exited():
	mouseEntered = false


func _on_vision_range_body_entered(body):
	if body.is_in_group("resources"):
		print("Possible resources sighted")
		possibleTargets.append(body)


func _on_vision_range_body_exited(body):
	if possibleTargets.has(body):
		print("Loss vision on resources")
		possibleTargets.erase(body)


func compareDistance(target_a, target_b):
	if position.distance_to(target_a.position) < position.distance_to(target_b.position):
		return true
	return false
	

func closestResource():
	if possibleTargets.size() > 0:
		possibleTargets.sort_custom(compareDistance)
		return possibleTargets[0]
	else:
		return null


func closestResourceWithinRange():
	if closestResource():
		if closestResource().position.distance_to(position) < gatherRange:
			return closestResource()
		return null
	return null


func targetWithinRange() -> bool:
	if gatherTarget.get_ref().position.distance_to(position) < gatherRange:
		return true
	else:
		return false


# Handles taking damage logic
func takeDamage(amount) -> bool:
	health -= amount
	print(health)
	if health <= 0:
		stateMachine.died()
		print("died")
		collisionShape.disabled = true
		return false
	else:
		return true


# Handles Dying of the Node
func removeNode():
	var path = get_tree().get_root().get_node("World")
	path.units.remove_at(path.units.find(self))


func _on_nav_timer_timeout():
	if navTarget:
		navAgent.target_position = navTarget
