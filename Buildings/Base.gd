extends StaticBody2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_contact_zone_body_entered(body):
	
	# Deposit resource
	# TODO - Check if the node that entered is a "Unit"
	if "Unit" in body.name:
		print("1.1 Worker unit detected")
		print("1.2 Unit is carrying: " + str(body.noOfCatnipCarrying))
		depositResource(body, body.noOfCatnipCarrying)
		body.goBackToResource(body.lastResourcePosition)
	
	if "Gatherer" in body.name:
		depositResource(body, body.noOfCatnipCarrying)
		
	
	pass # Replace with function body.


func _on_contact_zone_body_exited(body):
	pass # Replace with function body.

func depositResource(unit, noOfCatnip):
	Game.Catnip += noOfCatnip
	unit.noOfCatnipCarrying -= noOfCatnip
	print("1.3 Worker deposited Catnip")
	
	
