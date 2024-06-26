extends Control


@onready var levelAudioPlayer = get_node("AudioStreamPlayer2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	levelAudioPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://level_one.tscn")


func _on_level_2_pressed():
	get_tree().change_scene_to_file("res://level_two.tscn")


func _on_level_3_pressed():
	get_tree().change_scene_to_file("res://level_three.tscn")


func _on_quit_pressed():
	get_tree().quit()




func _on_level_4_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
