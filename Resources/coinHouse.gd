extends StaticBody2D


var totalTime = 50 #5 secs
var currentTime
var pop = preload("res://Global/Pop.tscn")

@onready var bar = $ProgressBar
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	currentTime = totalTime # currentTime = Time left
	bar.max_value = totalTime
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentTime <= 0:
		coinsCollected()


func _on_timer_timeout():
	currentTime -= 1
	var tween = get_tree().create_tween()
	tween.tween_property(bar, "value", currentTime,0.1).set_trans(Tween.TRANS_QUAD) # Animate Value in the Bar

func coinsCollected():
	Game.Coin += 10
	var popLabel = pop.instantiate()
	
	add_child(popLabel)
	popLabel.showValue(str(10),false)
	
	_ready()
