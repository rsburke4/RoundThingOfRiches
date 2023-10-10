extends Node2D
@export var scene_change:String

func reload_game():
	get_tree().change_scene_to_file(scene_change)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#On game over expects "WIN" or assumes anything else is a lose
func _on_game_over(state):
	$"Control".visible = true
	var background_anim = $"Control/AnimationPlayer"
	background_anim.play("BackgroundFade")
	#if state=="WIN":
		#Load win screne
	#	$Control/WinLable.text = "Yay You Win"
	#else:
		#Load lose screen
	#	$Control/WinLable.text = "Boo You Lost"
	
	$Control/WinLable.text = "Yay Player " + str(state) + " wins!"


func _on_button_button_up():
	reload_game()
