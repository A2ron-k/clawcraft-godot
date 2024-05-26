extends Area2D

@onready var fowSprite = get_node("Fow")


func _on_body_entered(body):
	if "unitOwner" in body:
		if body.unitOwner == 0:
			fowSprite.modulate.a = 0

func _on_body_exited(body):
	if "unitOwner" in body:
		if body.unitOwner == 0:
			fowSprite.modulate.a = 0.3
