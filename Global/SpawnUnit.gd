extends Node2D

@onready var unit = preload("res://Units/unit.tscn")
var buildingPosition

func _on_yes_pressed():
	var unitPath = get_tree().get_root().get_node("World/Units")
	var worldPath = get_tree().get_root().get_node("World")
	var newUnit = unit.instantiate()
	
	var MinimapPath = get_tree().get_root().get_node("World/UI/MiniMap/SubViewportContainer/SubViewport")
	MinimapPath._ready()
	
	# Randomise Unit Spawning location around building
	var randomPosX = randi_range(-50,50)
	var randomPosY = randi_range(-50,50)
	newUnit.position = buildingPosition + Vector2(randomPosX, randomPosY)
	newUnit.name = "Unit"
	
	print(newUnit.name)
	
	# Add unit to the unit group
	unitPath.add_child(newUnit)
	
	for i in unitPath.get_child_count():
		unitPath.get_child(i).name = "Unit"
	
	# Add unit to the world units
	worldPath.getUnits()



func _on_no_pressed():
	var buildingPath = get_tree().get_root().get_node("World/Buildings")
	
	# Handles the deselection
	# Searches for the buildings that have been selected then turning it to false
	for i in buildingPath.get_child_count():
		if buildingPath.get_child(i).selected == true:
			buildingPath.get_child(i).selected == false
	queue_free()
