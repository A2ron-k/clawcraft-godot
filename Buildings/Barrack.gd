extends StaticBody2D


# Children
@onready var select = get_node("Selected")
@onready var rtsRightPanel = get_tree().get_root().get_node("World/UI/RTSPanel/CenterSplit/RightPanel")

# Unit Selection
var mouseEntered = false
var selected = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	select.visible = selected

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
				if rtsRightPanel.has_node("UnitSpawner"):
					var spawnPanelPath = rtsRightPanel.get_node("UnitSpawner")
					spawnPanelPath.visible = true
				else:
					Game.spawnUnit()
					rtsRightPanel.get_node("UnitSpawner").visible = true
			else:
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
	if rtsRightPanel.has_node("UnitSpawner"):
		var spawnPanelPath = rtsRightPanel.get_node("UnitSpawner")
		spawnPanelPath.visible = false
