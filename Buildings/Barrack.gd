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
			selected = !selected
			if selected:
				Game.spawnUnit()
			else:
				if rtsRightPanel.has_node("UnitSpawner"):
					var spawnPanelPath = rtsRightPanel.get_node("UnitSpawner")
					spawnPanelPath.queue_free()

# Mouse Detection
func _on_barrack_mouse_entered():
	mouseEntered = true

func _on_barrack_mouse_exited():
	mouseEntered = false
