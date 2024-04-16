extends Camera2D

var mousePosition = Vector2()
var mousePositionGlobal = Vector2()
var start = Vector2()
var startVector = Vector2()
var end = Vector2()
var endVector = Vector2()
var isDragging = false

signal areaSelected
signal startMoveSelection


@onready var box = get_node("../UI/Panel")

func _ready():
	connect("areaSelected", Callable(get_parent(), "_onAreaSelected"))

func _process(delta):
	if Input.is_action_just_pressed("LeftClick"):
		start = mousePositionGlobal
		startVector = mousePosition
		isDragging = true
		
	if isDragging:
		end = mousePositionGlobal
		endVector = mousePosition
		drawArea()
		
	if Input.is_action_just_released("LeftClick"):
		if startVector.distance_to(mousePosition) > 20:
			end = mousePositionGlobal
			endVector = mousePosition
			isDragging = false
			drawArea(false)
			emit_signal("areaSelected", self)
		else:
			end = start
			isDragging = false
			drawArea(false)

func _input(event):
	if event is InputEventMouse:
		mousePosition = event.position
		mousePositionGlobal = get_global_mouse_position()


func drawArea(s=true):
	box.size = Vector2(abs(startVector.x - endVector.x), abs(startVector.y - endVector.y))
	
	var pos = Vector2()
	pos.x = min(startVector.x, endVector.x)
	pos.y = min(startVector.y, endVector.y)
	
	box.position = pos
	box.size *= int(s)
