extends StaticBody2D

# Children
var pop = preload("res://Global/Pop.tscn")
@onready var select = get_node("Selected")
@onready var rtsRightPanel = get_tree().get_root().get_node("World/UI/RTSPanel/CenterSplit/RightPanel")
@onready var buildingsPath = get_tree().get_root().get_node("World/Buildings")
@onready var healthBar = get_node("HealthBar")

# Unit Selection
var mouseEntered = false
var selected = false

# Unit Owner
@export var unitOwner := 0

# Unit Stats
var unitType = "building"
var typesWeakness = []
var health = 100
var armor = 1
var bonusDamage = 0

func _ready():	
	# Sets the enemy units to red
	if unitOwner == 1:
		modulate = Color(1, 0.29, 0.165,1)
	
	# Sets the healthbar value
	healthBar.max_value = health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	select.visible = selected

# Area detection
func _on_contact_zone_body_entered(body):
	# Deposit resource
	if "Gatherer" in body.name:
		if body.noOfCatnipCarrying > 0:
			depositResource(body, body.noOfCatnipCarrying)

func _on_contact_zone_body_exited(body):
	pass # Replace with function body.

# Handle updating of resource on UI and on Gatherer
func depositResource(unit, noOfCatnip):
	# Update the stats
	Game.Catnip += noOfCatnip
	unit.noOfCatnipCarrying -= noOfCatnip
	
	# Display the depositing indicator
	var popLabel = pop.instantiate()
	add_child(popLabel)
	popLabel.showValue(str(1),false)

# Mouse Detection
func _on_mouse_entered():
	mouseEntered = true

func _on_mouse_exited():
	mouseEntered = false

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
					if rtsRightPanel.has_node("GathererSpawner"):
						var spawnPanelPath = rtsRightPanel.get_node("GathererSpawner")
						spawnPanelPath.visible = true
					else:
						Game.spawnUnit()
						rtsRightPanel.get_node("GathererSpawner").visible = true
						
				else:
					healthBar.visible = selected
					if rtsRightPanel.has_node("UnitSpawner"):
						var spawnPanelPath = rtsRightPanel.get_node("GathererSpawner")
						spawnPanelPath.visible = false

func setSelected(value):
	selected = value
	healthBar.visible = false
	if rtsRightPanel.has_node("GathererSpawner"):
		var spawnPanelPath = rtsRightPanel.get_node("GathererSpawner")
		spawnPanelPath.visible = value

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
