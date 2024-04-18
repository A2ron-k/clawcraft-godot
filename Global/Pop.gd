extends Label

var travel = Vector2(0,-50)
var duration = 1
var spread = PI/2


func showValue(value, crit):
	var tween = get_tree().create_tween()
	text = "+" + str(value) + "g"
	pivot_offset = size / 4
	
	var movement = travel.rotated(randi_range(-spread/2, spread/2))
	
	#Animate Label Position
	# original position -> new position -> duration of movement
	tween.tween_property(self, "position", position + movement, duration)

	tween.tween_property(self, "modulate:a", 0.0, duration)
	
	#On hit...
	if crit == true:
		modulate = Color(1,0,0)
		scale = scale * 2
		tween.tween_property(self, "scale", scale, 0.4)
	
	tween.play()
	
	#After the fade out, we will remove the object using queue_free
	tween.tween_callback(self.queue_free)
	
