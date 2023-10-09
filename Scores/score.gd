extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_score(new_score):
	get_node("Score").text = str(new_score)
	
func reset_score():
	get_node("Score").text = "0"
	
func change_colors(bg_color, txt_color):
	color = bg_color
	get_node("Score").add_theme_color_override("font_color", txt_color)
