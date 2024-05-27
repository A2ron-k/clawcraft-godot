extends Button

@onready var label = get_node("DogCostLabel")

func _on_mouse_entered():
	label.visible = true


func _on_mouse_exited():
	label.visible = false
