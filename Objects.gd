extends Node2D


@onready var building = preload("res://Resources/coinHouse.tscn")
@onready var tree = preload("res://Resources/Tree.tscn")

var tile_size = 16
var numberOfTreeSpawns = 20

var grid_size = Vector2(80,45)
var grid = []



# Called when the node enters the scene tree for the first time.
func _ready():
	# Populate the 2D array with nulls
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)

	var treePositions = []
	
	for i in range(numberOfTreeSpawns):
		var xCoordinate = (randi() % int(grid_size.x))
		var yCoordinate = (randi() % int(grid_size.y))
		var gridPosition = Vector2(xCoordinate, yCoordinate)
		
		# Checks if the grid position already has a Tree in it, if not add a tree
		if not gridPosition in treePositions:
			treePositions.append(gridPosition)
		
	for currentPos in treePositions:
		var newTree = tree.instantiate()
		newTree.set_position(tile_size * currentPos)
		grid[currentPos.x][currentPos.y] = "new_tree"
		add_child(newTree)

