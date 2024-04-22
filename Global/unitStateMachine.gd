extends StateMachine

# Called when the node enters the scene tree for the first time.
func _ready():
	addState("idle")
	addState("moving")
	addState("engaging")
	addState("attacking")
	addState("dying")
	call_deferred("setState", states.idle)

func _input(event):
	if parent.selected and state!= states.dying:
		if Input.is_action_just_released("RightClick"):
			setState(states.idle)
			parent.movementTarget = parent.get_global_mouse_position()
			setState(states.moving)


func performStateLogic(delta):
	match state:
		states.idle:
			pass
		states.moving:
			parent.moveToTarget(delta, parent.movementTarget)
		states.engaging:
			pass
		states.attacking:
			pass
		states.dying:
			pass

func enterState(newState, previousState):
	var dx = abs(parent.position.x - parent.movementTarget.x)
	var dy = abs(parent.position.y - parent.movementTarget.y)
	
	match state:
		states.idle:
			parent.animation.stop()
			print("Entering Idle")
			pass
		states.moving:
			print("Entering Move")
			if dx > dy: 
				if parent.position.x < parent.movementTarget.x:
					parent.animation.play("WalkRight")
				elif parent.position.x > parent.movementTarget.x:
					parent.animation.play("WalkLeft")
			else: 
				if parent.position.y < parent.movementTarget.y:
					parent.animation.play("WalkDown")
				elif parent.position.y > parent.movementTarget.y:
					parent.animation.play("WalkUp")
		states.engaging:
			pass
		states.attacking:
			pass
		states.dying:
			pass

func getTransition(delta):
	match state:
		states.idle:
			pass
		states.moving:
			if parent.position.distance_to(parent.movementTarget) < 15:
				parent.movementTarget = parent.position
				setState(states.idle)
		states.engaging:
			pass
		states.attacking:
			pass
		states.dying:
			pass	
	pass

func _on_stop_timer_timeout():
	if parent.get_slide_collision_count():
		parent.currentDistanceToTarget = parent.position.distance_to(parent.movementTarget)
		if parent.lastDistanceToTarget < parent.currentDistanceToTarget + parent.move_threshold:
			parent.movementTarget = parent.position
			setState(states.idle)
