extends SubViewport

@onready var camera = $Camera
var barrack = preload("res://UI/Minimap Sprites/barracks_sprite.tscn")
var unit = preload("res://UI/Minimap Sprites/arthax_sprite.tscn")
var tree = preload("res://UI/Minimap Sprites/trees_sprite.tscn")
var coinHouse = preload("res://UI/Minimap Sprites/coinHouse_sprite.tscn")

@onready var buildingPath = get_tree().get_root().get_node("World/Buildings")
@onready var unitsPath = get_tree().get_root().get_node("World/Units")
@onready var treePath = get_tree().get_root().get_node("World/Objects")
@onready var coinHousePath = get_tree().get_root().get_node("World/CoinHouses")

# Called when the node enters the scene tree for the first time.
func _ready():
	updateMap()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var cameraPath = get_tree().get_root().get_node("World/Camera")
	
	camera.position = cameraPath.position/2
	camera.zoom = cameraPath.zoom/2
	
	var allUnits = get_node("Units")

	for i in unitsPath.get_child_count():
		allUnits.get_child(i).position = unitsPath.get_child(i).position

func updateMap():
	# Clear all the existing nodes that are not units
	for i in get_child_count()-3:
		get_child(i+3).queue_free()
	#
	for i in get_node("Units").get_child_count():
		get_node("Units").get_child(i).queue_free()
	
	# Put everything that exisit in the main world into the minimap world
	for i in buildingPath.get_child_count():
		var aBarrack = barrack.instantiate()
		add_child(aBarrack)
		aBarrack.position = buildingPath.get_child(i).position/2
	
	for i in unitsPath.get_child_count():
		var aUnit = unit.instantiate()
		get_node("Units").add_child(aUnit)
		aUnit.position = unitsPath.get_child(i).position/2
	
	for i in treePath.get_child_count():
		var aTree = tree.instantiate()
		add_child(aTree)
		aTree.position = treePath.get_child(i).position/2
		
	for i in coinHousePath.get_child_count():
		var aCoinHouse = coinHouse.instantiate()
		add_child(aCoinHouse)
		aCoinHouse.position = coinHousePath.get_child(i).position/2
