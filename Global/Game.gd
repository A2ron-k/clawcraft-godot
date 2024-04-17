extends Node

@onready var spawner = preload("res://Global/SpawnUnit.tscn")
var Catnip = 0

func spawnUnit(position):
	var path = get_tree().get_root().get_node("World/UI")
	
	var spawnUnit = spawner.instantiate()
	spawnUnit.buildingPosition = position
	
	var hasSpawn = false
	
	for i in path.get_child_count():
		if path.has_node("SpawnUnit"):
			hasSpawn = true

	if hasSpawn == false:
			path.add_child(spawnUnit) 
	
