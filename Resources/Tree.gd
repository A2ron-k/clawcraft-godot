extends StaticBody2D


# Children
@onready var timer = $Timer
@onready var bar = $ProgressBar

# Unit Stats
var totalResource = 50


# Called when the node enters the scene tree for the first time.
func _ready():
	bar.max_value = totalResource

# Area detection
func _on_collect_area_body_entered(body):
	if "Gatherer" in body.name:
		await get_tree().create_timer(5.0).timeout
		resourceGathered()
		body.noOfCatnipCarrying += 1

func _on_collect_area_body_exited(body):
	pass

# Handles resource logic when resource is gathered
func resourceGathered():
	var tween = get_tree().create_tween()
	totalResource -= 1
	tween.tween_property(bar, "value", totalResource, 1).set_trans(Tween.TRANS_QUAD) # Animate Value in the Bar
	
	if totalResource  <= 0:
		queue_free()
	
	# TODO - For the minimap
	#var MinimapPath = get_tree().get_root().get_node("World/UI/MiniMap/SubViewportContainer/SubViewport")
	#MinimapPath._ready()

