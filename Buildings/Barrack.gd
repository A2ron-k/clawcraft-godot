extends StaticBody2D


# Children
@onready var select = get_node("Selected")
@onready var rtsRightPanel = get_tree().get_root().get_node("World/UI/RTSPanel/CenterSplit/RightPanel")
@onready var healthBar = get_node("HealthBar")

# Unit Selection
var mouseEntered = false
var selected = false

# Unit Owner
@export var unitOwner := 0

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	select.visible = selected

# Handles Mouse Inputs
func _input(event):
	if event.is_action_pressed("LeftClick"):
		if mouseEntered:
				if unitOwner == 1:
					pass
				else:
					# Loop thru the nodes in the buildings and unselect the rest
					var buildings = get_tree().get_nodes_in_group("buildings")
					var instanceID = self.get_instance_id()
					
					for building in buildings:
						if is_instance_valid(building):
							if building.get_instance_id() != instanceID:
								building.setSelected(false)
								
					selected = !selected
					if selected:
						healthBar.visible = selected
						if rtsRightPanel.has_node("UnitSpawner"):
							var spawnPanelPath = rtsRightPanel.get_node("UnitSpawner")
							spawnPanelPath.visible = true
						else:
							Game.spawnUnit()
							rtsRightPanel.get_node("UnitSpawner").visible = true
					else:
						healthBar.visible = selected
						if rtsRightPanel.has_node("UnitSpawner"):
							var spawnPanelPath = rtsRightPanel.get_node("UnitSpawner")
							spawnPanelPath.visible = false

# Mouse Detection
func _on_barrack_mouse_entered():
	mouseEntered = true

func _on_barrack_mouse_exited():
	mouseEntered = false
	
func setSelected(value):
	selected = false
	healthBar.visible = false
	if rtsRightPanel.has_node("UnitSpawner"):
		var spawnPanelPath = rtsRightPanel.get_node("UnitSpawner")
		spawnPanelPath.visible = false

# Handles Take Damage Logic for the unit
func takeDamage(attackDamage, bonusModifier, armorModifier, unitType) -> bool:
	healthBar.visible = true
	print(attackDamage)
	print(armorModifier)
	# Damage Calculation 
	var finalDamage = attackDamage - armorModifier
	print(finalDamage)
	
	# Bonus Modifier
	if unitType in typesWeakness:
		finalDamage += bonusModifier
	
	health -= finalDamage
	print("finalDamage: ", finalDamage)
	print("health: ", health)
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

