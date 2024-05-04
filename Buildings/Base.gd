extends StaticBody2D

# Children
var pop = preload("res://Global/Pop.tscn")
@onready var select = get_node("Selected")
@onready var rtsRightPanel = get_tree().get_root().get_node("World/UI/RTSPanel/CenterSplit/RightPanel")
@onready var buildingsPath = get_tree().get_root().get_node("World/Buildings")

# Unit Selection
var mouseEntered = false
var selected = false


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
			
			# Loop thru the nodes in the buildings and unselect the rest
			var buildings = get_tree().get_nodes_in_group("buildings")
			var instanceID = self.get_instance_id()
			
			for building in buildings:
				if is_instance_valid(building):
					if building.get_instance_id() != instanceID:
						building.setSelected(false)
				
			selected = !selected
			if selected:
				if rtsRightPanel.has_node("GathererSpawner"):
					var spawnPanelPath = rtsRightPanel.get_node("GathererSpawner")
					spawnPanelPath.visible = true
				else:
					Game.spawnUnit()
					rtsRightPanel.get_node("GathererSpawner").visible = true
					
			else:
				if rtsRightPanel.has_node("UnitSpawner"):
					var spawnPanelPath = rtsRightPanel.get_node("GathererSpawner")
					spawnPanelPath.visible = false

func setSelected(value):
	selected = value
	if rtsRightPanel.has_node("GathererSpawner"):
		var spawnPanelPath = rtsRightPanel.get_node("GathererSpawner")
		spawnPanelPath.visible = value
