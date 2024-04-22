extends Node2D

var units = []

func _ready():
	#whenever game is loaded units are added to array
	getUnits()

func getUnits():
	units = get_tree().get_nodes_in_group("units")
	units += get_tree().get_nodes_in_group("meleeAttackers")

func _onAreaSelected(object):
	#object is the camera
	
	var start = object.start
	var end = object.end
	var area = []
	
	area.append(Vector2(min(start.x,end.x), min(start.y,end.y)))
	area.append(Vector2(max(start.x,end.x), max(start.y,end.y)))
	
	var unitsInArea = _getUnitsInArea(area)
	
	for unit in units:
		if is_instance_valid(unit):
			unit.setSelected(false)
	
	for unit in unitsInArea:
		unit.setSelected(!unit.selected)
	

func _getUnitsInArea(area):
	var unitsInArea = []
	
	for unit in units:
		if is_instance_valid(unit):
			#Check if unit is inside the area
			if (unit.position.x > area[0].x) and (unit.position.y < area[1].x):
				if (unit.position.y > area[0].y) and (unit.position.y < area[1].y):
					if unit.unitOwner == 0:
						unitsInArea.append(unit)
		else:
			# Handle invalid or freed units
			print("Invalid unit found:", unit)
			units.erase(unit)
			# You might want to remove the invalid unit from the units array here

	return unitsInArea
	
