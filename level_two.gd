extends Node2D

var units = [] # !VERY IMPORTANT - This tracks all the units in the game
var playerUnits = []
@onready var levelAudioPlayer = get_node("AudioStreamPlayer2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	getUnits() # Whenever game is loaded units are added to array
	getPlayerUnits()
	levelAudioPlayer.play()
	
func _process(delta):
	if playerUnits.size() <= 0:
		Game.isGameOver = true
	
# Retrieves all the units that are in the entire game that has been pre-spawned
func getUnits():
	units = get_tree().get_nodes_in_group("units")
	units.append(get_tree().get_nodes_in_group("meleeAttackers"))
	units.append(get_tree().get_nodes_in_group("rangeAttackers"))
	units.append(get_tree().get_nodes_in_group("buildings"))
	
func getPlayerUnits():
	for unit in units:
		if unit.unitOwner == 0:
			playerUnits.append(unit)

# Toggles the units's selected variable in an area
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

# Retrieves all the friendly units Array in the selected area
func _getUnitsInArea(area) -> Array:
	var unitsInArea = []
	
	for unit in units:
		if is_instance_valid(unit):
			#Check if unit is inside the area
			if (unit.position.x > area[0].x) and (unit.position.x < area[1].x):
				if (unit.position.y > area[0].y) and (unit.position.y < area[1].y):
					if unit.unitOwner == 0:
						unitsInArea.append(unit)
		else:
			# Handle invalid or freed units
			units.erase(unit)
	return unitsInArea



func _on_teleport_body_entered(body):
	get_tree().change_scene_to_file("res://world.tscn")
	pass # Replace with function body.
