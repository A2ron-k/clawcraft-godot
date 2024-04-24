extends StaticBody2D

var totalTime = 5
var currentTime
var units = 0
var totalResource = 50
@onready var timer = $Timer
@onready var bar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	#bar.max_value = totalTime
	#currentTime = totalTime
	bar.max_value = totalResource
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#bar.value = currentTime
	#if currentTime <= 0:
		#resourceGathered()
		#currentTime = totalTime
	pass

func _on_collect_area_body_entered(body):
	if "Unit" in body.name:
		units += 1
		startGathering(body)
		print("Start waiting")
		await get_tree().create_timer(5.0).timeout
		print("Wait Over")
		body.noOfCatnipCarrying += 1
		body.goBackToBase()
	
	if "Gatherer" in body.name:
		await get_tree().create_timer(5.0).timeout
		resourceGathered()
		body.noOfCatnipCarrying += 1
		


func _on_collect_area_body_exited(body):
	if "Unit" in body.name:
		units -= 1
		if units <= 0:
			timer.stop()
	

func _on_timer_timeout():
	var gatherSpeed = 1 * units # More units = Faster Gathering Time
	var tween = get_tree().create_tween()
	
	currentTime -= gatherSpeed
	tween.tween_property(bar, "value", currentTime,1).set_trans(Tween.TRANS_QUAD) # Animate Value in the Bar

func startGathering(body):
	timer.start()
	body.lastResourcePosition = self.position
	


func resourceGathered():
	var tween = get_tree().create_tween()
	totalResource -= 1
	tween.tween_property(bar, "value", totalResource, 1).set_trans(Tween.TRANS_QUAD) # Animate Value in the Bar
	
	if totalResource  <= 0:
		queue_free()
	pass
	#Game.Catnip += 1 #Add Amount of Resource
	#queue_free()
	#var MinimapPath = get_tree().get_root().get_node("World/UI/MiniMap/SubViewportContainer/SubViewport")
	#MinimapPath._ready()

