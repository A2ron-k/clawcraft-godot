extends Node


@onready var gathererSpawnerUI = preload("res://Global/gathererSpawner.tscn")
@onready var unitSpawnerUI = preload("res://Global/unitSpawner.tscn")


var Catnip = 0
var Coin = 0
var notification = ""

func spawnUnit():
	var UIpath = get_tree().get_root().get_node("World/UI/RTSPanel/CenterSplit/RightPanel")
	
	var spawnGatherer = gathererSpawnerUI.instantiate()
	var spawnUnit = unitSpawnerUI.instantiate()
	
	var hasSpawn = false
	
	if UIpath.has_node("UnitSpawner"):
		hasSpawn = true

	if hasSpawn == false:
		spawnUnit.visible = false
		spawnGatherer.visible = false
		UIpath.add_child(spawnUnit) 
		UIpath.add_child(spawnGatherer)

