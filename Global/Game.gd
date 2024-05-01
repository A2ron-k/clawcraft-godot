extends Node


@onready var spawner = preload("res://Global/SpawnUnit.tscn")
@onready var spawnerUI = preload("res://Global/unitSpawner.tscn")
var Catnip = 0
var Coin = 0
var notification = ""

func spawnUnit():
	var UIpath = get_tree().get_root().get_node("World/UI/RTSPanel/CenterSplit/RightPanel")
	
	var spawnUnit = spawnerUI.instantiate()
	
	var hasSpawn = false
	
	if UIpath.has_node("UnitSpawner"):
		hasSpawn = true

	if hasSpawn == false:
			UIpath.add_child(spawnUnit) 
