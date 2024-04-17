extends StaticBody2D

var mouseEntered = false
var selected = false
@onready var select = get_node("Selected")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	select.visible = selected


func _input(event):
	if event.is_action_pressed("LeftClick"):
		if mouseEntered:
			selected = !selected
			if selected:
				Game.spawnUnit(position)


func _on_barrack_mouse_entered():
	mouseEntered = true
	


func _on_barrack_mouse_exited():
	mouseEntered = false
	
