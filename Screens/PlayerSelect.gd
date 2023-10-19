extends Control

@export var scene_change:String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_button_1_button_up():
	PlayerGlobal.num_players = 1
	get_tree().change_scene_to_file(scene_change)

func _on_button_2_button_up():
	PlayerGlobal.num_players = 2
	get_tree().change_scene_to_file(scene_change)
	
func _on_button_3_button_up():
	PlayerGlobal.num_players = 3
	get_tree().change_scene_to_file(scene_change)

func _on_button_4_button_up():
	PlayerGlobal.num_players = 4
	get_tree().change_scene_to_file(scene_change)
	


func _on_button_1_mouse_entered():
	get_node("ClickPlayer").play()


func _on_button_2_mouse_entered():
	get_node("ClickPlayer").play()


func _on_button_3_mouse_entered():
	get_node("ClickPlayer").play()


func _on_button_4_mouse_entered():
	get_node("ClickPlayer").play()
