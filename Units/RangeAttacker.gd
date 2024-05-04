extends CharacterBody2D
class_name RangeAttacker


# Children
@onready var box = get_node("Box")
@onready var movementTarget = position
@onready var animation = get_node("AnimationPlayer")
@onready var stateMachine = get_node("RangeStateMachine")
@onready var collisionShape = get_node("CollisionShape2D")
@onready var navAgent = get_node("NavigationNode/NavigationAgent2D")
@onready var healthBar = get_node("HealthBar")

# Unit Owner
@export var unitOwner := 0

# Unit Selection
var mouseEntered = false
@export var selected = false

# Unit Movement
var followCursor = false
var speed = 100 
const move_threshold = 100 #How much closer to the target
var lastDistanceToTarget = Vector2.ZERO
var currentDistanceToTarget = Vector2.ZERO
@onready var stopTimer = get_node("StopTimer")

# Unit Navigation/ Pathfinding
var navTarget

# Unit Stats
var unitType = "lightArmor"
var typesWeakness = ["lightArmor"]
var health = 6
var damage = 2
var attackRange = 200
var armor = 2
var bonusDamage = 1

# Attacking Logic
var possibleTargets = []
var attackTarget = null


# Called when the node enters the scene tree for the first time.
func _ready():
	setSelected(selected)
	add_to_group("units", true)
	add_to_group("rangeAttackers", true)
	
	# Sets the enemy units to red
	if unitOwner == 1:
		modulate = Color(1, 0.29, 0.165,1)

	# Sets the healthbar value
	healthBar.max_value = health

# Handles user input
func _input(event):
	if event.is_action_pressed("LeftClick"):
		if mouseEntered && unitOwner == 0:
			setSelected(!selected)
	
	# TODO - Remove when finish updating Minimap feature
	#if(event.is_action_pressed("RightClick")):
		##var MinimapPath = get_tree().get_root().get_node("World/UI/MiniMap/SubViewportContainer/SubViewport")
		##MinimapPath._ready()
		#followCursor = true
	#
	#if(event.is_action_released("RightClick")):
		#followCursor = false
	#pass

# Handles variables that are related to being selected
func setSelected(value): 
	box.visible = value
	healthBar.visible = value
	selected = value

# Mouse detection
func _on_touch_zone_mouse_shape_entered(shape_idx):
	mouseEntered = true

func _on_touch_zone_mouse_shape_exited(shape_idx):
	mouseEntered = false

# Handle Movement to Target
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

# Handles Vision Range of Unit
func _on_vision_range_body_entered(body):
	if body.is_in_group("units") || body.is_in_group("buildings"):
		print("Possible unit sighted")
		if body.unitOwner != unitOwner:
			print("It is an enemy")
			possibleTargets.append(body)

func _on_vision_range_body_exited(body):
	if possibleTargets.has(body):
		print("Loss vision on Unit")
		possibleTargets.erase(body)

# Finds the closest enemy within Attack Range
func closestEnemyWithinRange():
	if closestEnemy():
		if closestEnemy().position.distance_to(position) < attackRange:
			return closestEnemy()
		return null
	return null

# Handles Distance Comparision between two targets
func compareDistance(target_a, target_b) -> bool:
	if position.distance_to(target_a.position) < position.distance_to(target_b.position):
		return true
	return false

# Finds the closest enemy
func closestEnemy():
	if possibleTargets.size() > 0:
		possibleTargets.sort_custom(compareDistance)
		return possibleTargets[0]
	else:
		return null

# Checks if target is within range
func targetWithinRange() -> bool:
	if attackTarget.get_ref().position.distance_to(position) < attackRange:
		return true
	else:
		return false

# Handles Take Damage Logic for the unit
func takeDamage(attackDamage, bonusModifier, armorModifier, unitType) -> bool:
	healthBar.visible = true
	
	# Damage Calculation 
	var finalDamage = attackDamage - armorModifier
	
	# Bonus Modifier
	if unitType in typesWeakness:
		finalDamage += bonusModifier
	
	health -= finalDamage
	
	# Healthbar animation
	var tween = get_tree().create_tween()
	tween.tween_property(healthBar, "value", health,0.1).set_trans(Tween.TRANS_QUAD)
	
	if health <= 0:
		stateMachine.died()
		collisionShape.disabled = true
		return false
	else:
		return true

# Handles deletion of the unit from the Game Unit Array
func removeNode():
	var path = get_tree().get_root().get_node("World")
	path.units.remove_at(path.units.find(self))

# Prompts unit path recalculation 
func _on_nav_timer_timeout():
	if navTarget:
		navAgent.target_position = navTarget



