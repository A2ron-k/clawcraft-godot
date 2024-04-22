extends Node
class_name StateMachine

var state = null
var previousState = null
var states = {}

@onready var parent = get_parent()

func _physics_process(delta):
	if state != null:
		performStateLogic(delta) #Perform state logic
		var transition = getTransition(delta) # Checks if there is a need to change states
		if transition != null:
			setState(transition)

func addState(stateName):
	states[stateName] = states.size()
	
func performStateLogic(delta):
	pass

func getTransition(delta):
	pass

func exitState(previousState, newState):
	pass

func enterState(newState, previousState):
	pass
	
func setState(newState):
	previousState = state
	state = newState
	
	if previousState != null:
		exitState(previousState, newState)
	if newState != null:
		enterState(newState, previousState)
	
	

