extends StaticBody2D

var totalTime = 5
var currentTime
var units = 0
@onready var timer = $Timer
@onready var bar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	bar.max_value = totalTime
	currentTime = totalTime
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bar.value = currentTime
	if currentTime <= 0:
		resourceGathered()
	pass

func _on_collect_area_body_entered(body):
	
	if "Unit" in body.name:
		units += 1
		startGathering()
		
	pass # Replace with function body.


func _on_collect_area_body_exited(body):
	if "Unit" in body.name:
		units -= 1
		if units <= 0:
			timer.stop()
	


func _on_timer_timeout():
	var gatherSpeed = 1 * units # More units = Faster Gathering Time
	var tween = get_tree().create_tween()
	
	currentTime -= gatherSpeed
	tween.tween_property(bar, "value", currentTime,0.8).set_trans(Tween.TRANS_QUAD) # Animate Value in the Bar

func startGathering():
	timer.start()


func resourceGathered():
	Game.Catnip += 1 #Add Amount of Resource 
	queue_free()
	pass

