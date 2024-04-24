extends CharacterBody2D
class_name MeleeAttacker

# Unit Selection
var mouseEntered = false
@export var selected = false

# Children
@onready var box = get_node("Box")
@onready var movementTarget = position
@onready var animation = get_node("AnimationPlayer")
@onready var stateMachine = get_node("UnitStateMachine")
@onready var collisionShape = get_node("CollisionShape2D")
@onready var navAgent = get_node("NavigationNode/NavigationAgent2D")

# Unit Owner
@export var unitOwner := 0

# Unit Movement
var followCursor = false
var speed = 100
const move_threshold = 100 #How much closer to the target
var lastDistanceToTarget = Vector2.ZERO
var currentDistanceToTarget = Vector2.ZERO
@onready var stopTimer = $StopTimer

# Unit Navigation/ Pathfinding
var navTarget

# Attacking Logic
var attackRange = 20
var health = 10
var damage = 2
var possibleTargets = []
var attackTarget = null


func _ready():
	setSelected(selected)
	add_to_group("units", true)
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
		if mouseEntered && unitOwner == 0:
			setSelected(!selected)
	
	if(event.is_action_pressed("RightClick")):
		#var MinimapPath = get_tree().get_root().get_node("World/UI/MiniMap/SubViewportContainer/SubViewport")
		#MinimapPath._ready()
		followCursor = true
	
	if(event.is_action_released("RightClick")):
		followCursor = false
	pass


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


func _on_meleeAttacker_mouse_entered():
	mouseEntered = true


func _on_meleeAttacker_mouse_exited():
	mouseEntered = false


func _on_vision_range_body_entered(body):
	if body.is_in_group("units"):
		print("Possible unit sighted")
		if body.unitOwner != unitOwner:
			print("It is an enemy")
			possibleTargets.append(body)

func _on_vision_range_body_exited(body):
	if possibleTargets.has(body):
		print("Loss vision on Unit")
		possibleTargets.erase(body)

func compareDistance(target_a, target_b):
	if position.distance_to(target_a.position) < position.distance_to(target_b.position):
		return true
	return false

func closestEnemy():
	if possibleTargets.size() > 0:
		possibleTargets.sort_custom(compareDistance)
		return possibleTargets[0]
	else:
		return null
		

func closestEnemyWithinRange():
	if closestEnemy():
		if closestEnemy().position.distance_to(position) < attackRange:
			return closestEnemy()
		return null
	return null


func targetWithinRange() -> bool:
	if attackTarget.get_ref().position.distance_to(position) < attackRange:
		return true
	else:
		return false

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
	
func removeNode():
	var path = get_tree().get_root().get_node("World")
	path.units.remove_at(path.units.find(self))


func _on_nav_timer_timeout():
	if navTarget:
		navAgent.target_position = navTarget
