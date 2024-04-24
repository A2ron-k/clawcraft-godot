extends StateMachine

enum Commands {
	NONE,
	MOVE,
	GATHER,
	RETURN
}

var command = Commands.NONE

# Attack Move Modifier
enum CommandModifiers {
	NONE,
	GATHER_MOVE
}

var commandModifier

# Called when the node enters the scene tree for the first time.
func _ready():
	addState("idle")
	addState("moving")
	addState("gathering")
	addState("returning")
	addState("dying")
	call_deferred("setState", states.idle)

func _input(event):
	if parent.selected and state!= states.dying:
		if Input.is_action_pressed("Gather"):
			commandModifier = CommandModifiers.GATHER_MOVE
			
		if Input.is_action_pressed("Return"):
			print("Return")
			command = Commands.RETURN
			setState(states.returning)
		
		if Input.is_action_just_released("RightClick"):
			parent.movementTarget = parent.get_global_mouse_position()
			setState(states.moving)
			
			match commandModifier:
				CommandModifiers.NONE:
					command = Commands.MOVE
				CommandModifiers.GATHER_MOVE:
					command = Commands.GATHER

func performStateLogic(delta):
	match state:
		states.idle:
			pass
		states.moving:
			parent.moveToTarget(delta, parent.movementTarget)
		states.gathering:
			 # Logic for gathering resources
			#parent.collisionShape.disabled = true
			if parent.gatherTarget.get_ref():
				parent.moveToTarget(delta, parent.gatherTarget.get_ref().position)
			else:
				setState(states.idle)
		states.returning:
			# Logic for returning to base
			#parent.collisionShape.disabled = false
			parent.moveToTarget(delta, parent.homeBasePosition)
			
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
			print("Entering Moving")
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
		states.gathering:
			print("Entering Gathering")
			var dx = abs(parent.position.x - parent.gatherTarget.get_ref().position.x)
			var dy = abs(parent.position.y - parent.gatherTarget.get_ref().position.y)
			if dx > dy: 
				if parent.position.x < parent.gatherTarget.get_ref().position.x:
					parent.animation.play("GatherRight")
				elif parent.position.x > parent.gatherTarget.get_ref().position.x:
					parent.animation.play("GatherLeft")
			else: 
				if parent.position.y < parent.gatherTarget.get_ref().position.y:
					parent.animation.play("GatherDown")
				elif parent.position.y > parent.gatherTarget.get_ref().position.y:
					parent.animation.play("GatherUp")
		states.returning:
			print("Entering Return")
			var dx = abs(parent.position.x - parent.homeBasePosition.x)
			var dy = abs(parent.position.y - parent.homeBasePosition.y)
			if dx > dy: 
				if parent.position.x < parent.homeBasePosition.x:
					parent.animation.play("WalkRight")
				elif parent.position.x > parent.homeBasePosition.x:
					parent.animation.play("WalkLeft")
			else: 
				if parent.position.y < parent.homeBasePosition.y:
					parent.animation.play("WalkDown")
				elif parent.position.y > parent.homeBasePosition.y:
					parent.animation.play("WalkUp")
		#states.attacking:
			#var dx = abs(parent.position.x - parent.attackTarget.get_ref().position.x)
			#var dy = abs(parent.position.y - parent.attackTarget.get_ref().position.y)
			#if dx > dy: 
				#if parent.position.x < parent.attackTarget.get_ref().position.x:
					#parent.animation.play("attackRight")
				#elif parent.position.x > parent.attackTarget.get_ref().position.x:
					#parent.animation.play("attackLeft")
			#else: 
				#if parent.position.y < parent.attackTarget.get_ref().position.y:
					#parent.animation.play("attackDown")
				#elif parent.position.y > parent.attackTarget.get_ref().position.y:
					#parent.animation.play("attackUp")
		states.dying:
			pass

func getTransition(delta):
	match state:
		states.idle:
			match command:
				Commands.GATHER:
					setState(states.moving)
				
				Commands.NONE:
					if parent.closestResource() != null:
						parent.gatherTarget = weakref(parent.closestResource())
						setState(states.gathering)

		states.moving:
			if command == Commands.GATHER:
				if parent.closestResource() != null:
					parent.gatherTarget  = weakref(parent.closestResource())
					setState(states.gathering)
					
			if parent.position.distance_to(parent.movementTarget) < 15:
					parent.movementTarget = parent.position
					command = Commands.NONE
					setState(states.idle)
					
		states.gathering:
			if parent.noOfCatnipCarrying > 0:
				setState(states.returning)
			else:
				if parent.closestResourceWithinRange() != null:
					parent.gatherTarget  = weakref(parent.closestResource())
					setState(states.gathering)
			pass
			
		states.returning:
			if command == Commands.RETURN:
				pass
			else:
				if parent.noOfCatnipCarrying <= 0:
					setState(states.gathering)
				#setState(states.idle)	
			pass
				
		#states.attacking:
			##if !parent.attackTarget.get_ref():
				##setState(states.idle)
				##parent.attackTarget = null
			#pass
				
		states.dying:
			parent.removeNode()
			parent.queue_free()
	pass

func _on_stop_timer_timeout():
	if state != states.dying:
		if parent.get_slide_collision_count():
			parent.currentDistanceToTarget = parent.position.distance_to(parent.movementTarget)
			if parent.lastDistanceToTarget < parent.currentDistanceToTarget + parent.move_threshold:
				parent.movementTarget = parent.position
				setState(states.idle)
				command = Commands.NONE

func died():
	setState(states.dying)


func _on_animation_player_animation_finished(anim_name):
	match state:
		#states.attacking:
			#if parent.gatherTarget.get_ref():
				#if parent.gatherTarget.get_ref().takeDamage(parent.damage):
					#if parent.targetWithinRange():
						#parent.animation.play()
					#else:
						#setState(states.engaging)
				#else:
					#setState(states.idle)
			#else:
				#setState(states.idle)
		states.dying:
			parent.queue_free()
	

