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
			print(parent.attackTarget.get_ref().position)
			parent.moveToTarget(delta, parent.attackTarget.get_ref().movementTarget)
		states.attacking:
			pass
		states.dying:
			pass

func enterState(newState, previousState):

	
	match state:
		states.idle:
			parent.animation.stop()
			print("Entering Idle")
			pass
		states.moving:
			print("Entering Move")
			var dx = abs(parent.position.x - parent.movementTarget.x)
			var dy = abs(parent.position.y - parent.movementTarget.y)
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
			var dx = abs(parent.position.x - parent.attackTarget.get_ref().position.x)
			var dy = abs(parent.position.y - parent.attackTarget.get_ref().position.y)
			if dx > dy: 
				if parent.position.x < parent.attackTarget.get_ref().position.x:
					parent.animation.play("attackRight")
				elif parent.position.x > parent.attackTarget.get_ref().position.x:
					parent.animation.play("attackLeft")
			else: 
				if parent.position.y < parent.attackTarget.get_ref().position.y:
					parent.animation.play("attackDown")
				elif parent.position.y > parent.attackTarget.get_ref().position.y:
					parent.animation.play("attackUp")
		states.attacking:
			pass
		states.dying:
			pass

func getTransition(delta):
	match state:
		states.idle:
			if parent.closestEnemy() != null:
				parent.attackTarget  = weakref(parent.closestEnemy())
				setState(states.engaging)
		states.moving:
			if parent.position.distance_to(parent.movementTarget) < 15:
				parent.movementTarget = parent.position
				setState(states.idle)
		states.engaging:
			if parent.closestEnemyWithinRange() != null:
				parent.attackTarget  = weakref(parent.closestEnemy())
				setState(states.attacking)
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
