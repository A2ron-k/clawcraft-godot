extends Camera2D

# Camera Control
@export var speed = 20.0
@export var edgeSpeed = 50.0
@export var zoomSpeed = 20.0
@export var zoomMargin = 0.1
@export var zoomMinimum = 1.0
@export var zoomMaximum = 3.0
var zoomFactor = 1
var zoomPosition = Vector2()
var isZooming = false

# Edge Scrolling
var edgeScrollMargin = 200

# Mouse Tracking
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
	# Handle camera movement by arrow keys
	var inputX = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var inputY = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	position.x = lerp(position.x, position.x + inputX * speed * zoom.x, speed * delta)
	position.y = lerp(position.y, position.y + inputY * speed * zoom.y, speed * delta)
	
	## Edge scrolling by mouse position
	var screenSize = get_viewport_rect().size
	if mousePosition.x < edgeScrollMargin:
		inputX -= 1
	elif mousePosition.x > screenSize.x - edgeScrollMargin:
		inputX += 1
	if mousePosition.y < edgeScrollMargin:
		inputY -= 1
	elif mousePosition.y > screenSize.y - edgeScrollMargin:
		inputY += 1
	
	position.x += inputX * edgeSpeed * delta * zoom.x
	position.y += inputY * edgeSpeed * delta * zoom.y
	
	# Handle camera zoom
	zoom.x = lerp(zoom.x, zoom.x * zoomFactor, zoomSpeed * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoomFactor, zoomSpeed * delta)
	
	zoom.x = clamp(zoom.x, zoomMinimum, zoomMaximum)
	zoom.y = clamp(zoom.y, zoomMinimum, zoomMaximum)
	
	if !isZooming:
		zoomFactor = 1.0
	
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
	if abs(zoomPosition.x - get_global_mouse_position().x) > zoomMargin:
		zoomFactor = 1.0
	if abs(zoomPosition.y - get_global_mouse_position().y) > zoomMargin:
		zoomFactor = 1.0
	
	if event is InputEventMouseButton or InputEventKey:
		if event.is_pressed():
			isZooming = true
			
			if event.is_action("WheelDown"):
				position = get_global_mouse_position() 
				zoomFactor -= 0.01 * zoomSpeed
				zoomPosition = get_global_mouse_position()
			if event.is_action("WheelUp"):
				position = get_global_mouse_position() 
				zoomFactor += 0.01 * zoomSpeed
				zoomPosition = get_global_mouse_position()
		else:
			isZooming = false
	
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
	
	var MinimapPath = get_tree().get_root().get_node("World/UI/MiniMap/SubViewportContainer/SubViewport")
	MinimapPath._ready()
