extends Node


@onready var spawner = preload("res://Global/SpawnUnit.tscn")
@onready var spawnerUI = preload("res://Global/unitSpawner.tscn")
var Catnip = 0
var Coin = 0
var notification = ""

func spawnUnit():
	var UIpath = get_tree().get_root().get_node("World/UI/RTSPanel/CenterSplit/RightPanel")
	
	var spawnUnit = spawnerUI.instantiate()
	UIpath.add_child(spawnUnit)
	pass

#func spawnUnit(position):
	#var path = get_tree().get_root().get_node("World/UI")
	#
	#var spawnUnit = spawner.instantiate()
	#spawnUnit.buildingPosition = position
	#
	#var hasSpawn = false
	#
	#for i in path.get_child_count():
		#if path.has_node("SpawnUnit"):
			#hasSpawn = true
#
	#if hasSpawn == false:
			#path.add_child(spawnUnit) 
	#
