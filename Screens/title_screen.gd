extends Node2D
@export var scene_change:String

# Called when the node enters the scene tree for the first time.
func change_scene():
	get_tree().change_scene_to_file(scene_change)

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_button_button_up():
	change_scene()


func _on_button_mouse_entered():
	get_node("AudioStreamPlayer2D").play()
