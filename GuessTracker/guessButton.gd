extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	reset_button()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reset_button():
	disabled = false


func _on_pressed():
	print(text)
	
	disabled = true
