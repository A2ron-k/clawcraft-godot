extends StaticBody2D


var pop = preload("res://Global/Pop.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Area detection
func _on_contact_zone_body_entered(body):
	# Deposit resource
	if "Gatherer" in body.name:
		if body.noOfCatnipCarrying > 0:
			depositResource(body, body.noOfCatnipCarrying)

func _on_contact_zone_body_exited(body):
	pass # Replace with function body.

# Handle updating of resource on UI and on Gatherer
func depositResource(unit, noOfCatnip):
	# Update the stats
	Game.Catnip += noOfCatnip
	unit.noOfCatnipCarrying -= noOfCatnip
	
	# Display the depositing indicator
	var popLabel = pop.instantiate()
	add_child(popLabel)
	popLabel.showValue(str(1),false)
	
	
