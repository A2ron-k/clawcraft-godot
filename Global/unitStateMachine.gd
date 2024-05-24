extends StateMachine

enum Commands {
	NONE,
	MOVE,
	ATTACK_MOVE,
	HOLD
}

var command = Commands.NONE

# Attack Move Modifier
enum CommandModifiers {
	NONE,
	ATTACK_MOVE
}

var commandModifier

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
		if Input.is_action_pressed("AttackMove"):
			commandModifier = CommandModifiers.ATTACK_MOVE
			
		if Input.is_action_pressed("Hold"):
			command = Commands.HOLD
			setState(states.idle)
			
		if Input.is_action_just_released("RightClick"):
			parent.movementTarget = parent.get_global_mouse_position()
			setState(states.moving)
			
			match commandModifier:
				CommandModifiers.NONE:
					command = Commands.MOVE
				CommandModifiers.ATTACK_MOVE:
					command = Commands.ATTACK_MOVE

func performStateLogic(delta):
	match state:
		states.idle:
			pass
		states.moving:
			parent.moveToTarget(delta, parent.movementTarget)
		states.engaging:
			if parent.attackTarget.get_ref():
				if parent.attackTarget.get_ref().unitType == "building":
					parent.moveToTarget(delta, parent.attackTarget.get_ref().position)
				else:
					parent.moveToTarget(delta, parent.attackTarget.get_ref().movementTarget)
			else:
				setState(states.idle)
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
					parent.animation.play("WalkRight")
				elif parent.position.x > parent.attackTarget.get_ref().position.x:
					parent.animation.play("WalkLeft")
			else: 
				if parent.position.y < parent.attackTarget.get_ref().position.y:
					parent.animation.play("WalkDown")
				elif parent.position.y > parent.attackTarget.get_ref().position.y:
					parent.animation.play("WalkUp")
		states.attacking:
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
		states.dying:
			pass

func getTransition(delta):
	match state:
		states.idle:
			match command:
				Commands.HOLD:
					if parent.closestEnemyWithinRange() != null:
						parent.attackTarget = weakref(parent.closestEnemyWithinRange())
						setState(states.attacking)
				
				Commands.ATTACK_MOVE:
					setState(states.moving)
				
				Commands.NONE:
					if parent.closestEnemy() != null:
						parent.attackTarget = weakref(parent.closestEnemy())
						setState(states.engaging)

		states.moving:
			if command == Commands.ATTACK_MOVE:
				if parent.closestEnemy() != null:
					parent.attackTarget  = weakref(parent.closestEnemy())
					setState(states.engaging)
					
			if parent.position.distance_to(parent.movementTarget) < 15:
					parent.movementTarget = parent.position
					command = Commands.NONE
					setState(states.idle)
					
		states.engaging:
			if parent.closestEnemyWithinRange() != null:
				parent.attackTarget  = weakref(parent.closestEnemy())
				setState(states.attacking)
				
		states.attacking:
			if !parent.attackTarget.get_ref():
				setState(states.idle)
				parent.attackTarget = null
				
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
		states.attacking:
			if parent.attackTarget.get_ref():
				if parent.attackTarget.get_ref().takeDamage(parent.damage, parent.bonusDamage, parent.attackTarget.get_ref().armor, parent.attackTarget.get_ref().unitType):
					if parent.targetWithinRange():
						parent.animation.play()
						parent.attackAudioPlayer.play()
					else:
						setState(states.engaging)
				else:
					setState(states.idle)
			else:
				setState(states.idle)
		states.dying:
			parent.queue_free()
	

