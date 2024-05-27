extends StaticBody2D


# Children
@onready var healthBar = get_node("HealthBar")

# Unit Owner
@export var unitOwner := 1

# Unit Stats
var unitType = "building"
var typesWeakness = []
var health = 50
var armor = 0
var bonusDamage = 0
#var movementTarget = position

func _ready():	
	# Sets the enemy units to red
	if unitOwner == 1:
		modulate = Color(1, 0.29, 0.165,1)
	
	# Sets the healthbar value
	healthBar.max_value = health

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
		queue_free()
		return false
	else:
		return true

# Handles deletion of the unit from the Game Unit Array
func removeNode():
	var path = get_tree().get_root().get_node("World")
	path.units.remove_at(path.units.find(self))
	path.enemyBuildings.remove_at(path.enemyBuildings.find(self))
	path.units.erase(self)
	path.enemyBuildings.erase(path.enemyBuildings.find(self))

