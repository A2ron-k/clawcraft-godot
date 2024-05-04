extends Node2D


# Timers
@onready var timer = $Timer
@onready var tickTimer = $TickTimer
@onready var cooldownBar = $CooldownBar
@onready var isTimerStarted = false

var totalTime = 50 #5 secs
var currentTime = 0

# Units & Buttons
@onready var gatherer = preload("res://Units/Gatherer.tscn")
@onready var spawnGathererBtn = $HBoxContainer/Gatherer

var gathererUnitSpawnCost = 2
#var meleeUnitSpawnCost = 4
#var rangeUnitSpawnCost = 5
#var heavyUnitSpawnCost = 5

func _process(delta):
	enableButtons()

func _on_gatherer_pressed():
	var worldPath = get_tree().get_root().get_node("World")
	var gathererPath = get_tree().get_root().get_node("World/Gatherers")
	var basePath = get_tree().get_root().get_node("World/HomeBase/Base")
	var gathererCount = gathererPath.get_child_count() # Count how many gathers there are... 
	
	# Check how much Catnips the person has, if have enough then spawn
	if Game.Catnip >= gathererUnitSpawnCost:
		Game.Catnip -= gathererUnitSpawnCost
		
		startTimer()
		await get_tree().create_timer(4.9).timeout
		
		var newGatherer = gatherer.instantiate()
		newGatherer.name = "Gatherer" + str(gathererCount + 1) # name them accordingly
		
		# Spawning in front of the base
		var randomPosX = randi_range(-10,10)
		var randomPosY = randi_range(30,50)
		newGatherer.position = basePath.position + Vector2(randomPosX, randomPosY)
		
		# Add the units to the respective nodes and arrays
		gathererPath.add_child(newGatherer)
		worldPath.getUnits()
	else:
		# Display the notication
		Game.notification = "Not Enough Catnips to spawn a Gatherer"
		await get_tree().create_timer(3.0).timeout
		Game.notification = ""

	
# Disables all buttons
func disableAllButtons():
	spawnGathererBtn.disabled = true

# Enables all buttons if they meet the conditions
func enableButtons():
	# TODO - Add any new buttons
	if isTimerStarted == false:
		if Game.Catnip >= gathererUnitSpawnCost:
			spawnGathererBtn.disabled = false
		else:
			spawnGathererBtn.disabled = true

# Handles the "when" to disable of button
func startTimer():
	currentTime = totalTime # currentTime = Time left
	cooldownBar.max_value = totalTime
	
	timer.start()
	isTimerStarted = true
	disableAllButtons()
	

# Handles the "when" to re-enable of button
func _on_timer_timeout():
	print("timer finished")
	isTimerStarted = false
	enableButtons()

# Handles the progress bar ticking
func _on_tick_timer_timeout():
	currentTime -= 1
	var tween = get_tree().create_tween()
	tween.tween_property(cooldownBar, "value", currentTime,0.1).set_trans(Tween.TRANS_QUAD) # Animate Value in the Bar

