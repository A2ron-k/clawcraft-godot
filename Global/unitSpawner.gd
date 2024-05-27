extends Node2D


# Timers
@onready var timer = $Timer
@onready var tickTimer = $TickTimer
@onready var cooldownBar = $CooldownBar
@onready var isTimerStarted = false

var totalTime = 50 #5 secs
var currentTime = 0

# Units & Buttons
@onready var catMarine = preload("res://Units/RangeAttacker.tscn") 
@onready var spawnCatMarineBtn = $HBoxContainer/Marine
@onready var catMarineSprite = $HBoxContainer/CatMarineSprite

@onready var liberatedDog = preload("res://Units/MeleeAttacker.tscn")
@onready var spawnMeleeBtn = $HBoxContainer/Melee
@onready var meleeSprite = $HBoxContainer/ChiwawaSprite

@onready var flameCat = preload("res://Units/FlameRangeCat.tscn")
@onready var spawnFlameBtn = $HBoxContainer/Flame

var marineUnitSpawnCost = 5
var liberatedMeleeDogSpawnCost = 2
var flameUnitSpawnCost = 7

func _process(delta):
	enableButtons()

# Disables all buttons
func disableAllButtons():
	spawnCatMarineBtn.disabled = true
	spawnMeleeBtn.disabled = true
	spawnFlameBtn.disabled = true
	

# Enables all buttons if they meet the conditions
func enableButtons():
	# TODO - Add any new buttons
	
	if isTimerStarted == false:
		if Game.Catnip >= flameUnitSpawnCost:
			spawnFlameBtn.disabled = false
		else:
			spawnFlameBtn.disabled = true
			
	
	if isTimerStarted == false:
		if Game.Catnip >= liberatedMeleeDogSpawnCost:
			spawnMeleeBtn.disabled = false
			meleeSprite.modulate = Color(1, 1, 1)
		else:
			spawnMeleeBtn.disabled = true
			meleeSprite.modulate = Color(0.286, 0.286, 0.286)
	
	if isTimerStarted == false:
		if Game.Catnip >= marineUnitSpawnCost:
			spawnCatMarineBtn.disabled = false
			catMarineSprite.modulate = Color(1, 1, 1)
		else:
			spawnCatMarineBtn.disabled = true
			catMarineSprite.modulate = Color(0.286, 0.286, 0.286)

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


func _on_marine_pressed():
	var worldPath = get_tree().get_root().get_node("World")
	var rangeAttackersPath = get_tree().get_root().get_node("World/RangeAttackers")
	var barrackPath = get_tree().get_root().get_node("World/Buildings/Barrack")
	var rangeAttackersCount = rangeAttackersPath.get_child_count() # Count how many rangeAttackers there are... 
	
	# Check how much Catnips the person has, if have enough then spawn
	if Game.Catnip >= marineUnitSpawnCost:
		Game.Catnip -= marineUnitSpawnCost
		
		startTimer()
		await get_tree().create_timer(4.9).timeout
		
		var newCatMarine = catMarine.instantiate()
		newCatMarine.name = "CatMarine" + str(rangeAttackersCount + 1) # name them accordingly
		
		# Spawning in front of the base
		var randomPosX = randi_range(-10,10)
		var randomPosY = randi_range(30,50)
		newCatMarine.position = barrackPath.position + Vector2(randomPosX, randomPosY)
		
		# Add the units to the respective nodes and arrays
		rangeAttackersPath.add_child(newCatMarine)
		worldPath.getUnits()
	else:
		# Display the notication
		Game.notification = "Not Enough Catnips to spawn a Cat Marine"
		await get_tree().create_timer(3.0).timeout
		Game.notification = ""



func _on_flame_pressed():
	var worldPath = get_tree().get_root().get_node("World")
	var rangeAttackersPath = get_tree().get_root().get_node("World/RangeAttackers")
	var barrackPath = get_tree().get_root().get_node("World/Buildings/Barrack")
	var rangeAttackersCount = rangeAttackersPath.get_child_count() # Count how many rangeAttackers there are... 
	
	# Check how much Catnips the person has, if have enough then spawn
	if Game.Catnip >= flameUnitSpawnCost:
		Game.Catnip -= flameUnitSpawnCost
		
		startTimer()
		await get_tree().create_timer(4.9).timeout
		
		var newFlameCat = flameCat.instantiate()
		newFlameCat.name = "FlameCat" + str(rangeAttackersCount + 1) # name them accordingly
		
		# Spawning in front of the base
		var randomPosX = randi_range(-10,10)
		var randomPosY = randi_range(30,50)
		newFlameCat.position = barrackPath.position + Vector2(randomPosX, randomPosY)
		
		# Add the units to the respective nodes and arrays
		rangeAttackersPath.add_child(newFlameCat)
		worldPath.getUnits()
	else:
		# Display the notication
		Game.notification = "Not Enough Catnips to spawn a Flame Cat"
		await get_tree().create_timer(3.0).timeout
		Game.notification = ""


func _on_melee_pressed():
	var worldPath = get_tree().get_root().get_node("World")
	var meleeAttackerPath = get_tree().get_root().get_node("World/meleeAttackers")
	var barrackPath = get_tree().get_root().get_node("World/Buildings/Barrack")
	var meleeAttackerCount = meleeAttackerPath.get_child_count() # Count how many rangeAttackers there are... 
	
	# Check how much Catnips the person has, if have enough then spawn
	if Game.Catnip >= liberatedMeleeDogSpawnCost:
		Game.Catnip -= liberatedMeleeDogSpawnCost
		
		startTimer()
		await get_tree().create_timer(4.9).timeout
		
		var newDogCat = liberatedDog.instantiate()
		newDogCat.name = "LiberatedDog" + str(meleeAttackerCount + 1) # name them accordingly
		
		# Spawning in front of the base
		var randomPosX = randi_range(-10,10)
		var randomPosY = randi_range(30,50)
		newDogCat.position = barrackPath.position + Vector2(randomPosX, randomPosY)
		
		# Add the units to the respective nodes and arrays
		meleeAttackerPath.add_child(newDogCat)
		worldPath.getUnits()
	else:
		# Display the notication
		Game.notification = "Not Enough Catnips to spawn a Liberated Dog."
		await get_tree().create_timer(3.0).timeout
		Game.notification = ""
