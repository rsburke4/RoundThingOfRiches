extends Panel

var stylebox_panel = get_theme_stylebox("panel").duplicate()
# Called when the node enters the scene tree for the first time.
func _ready():
	set_style(stylebox_panel, Colors.COLOR_SCORE_BKGD_INACTIVE, Colors.COLOR_SCORE_BORDER_INACTIVE)
	add_theme_stylebox_override("panel", stylebox_panel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func update_score(new_score):
	get_node("Score").text = str(new_score)
	
func reset_score():
	get_node("Score").text = "0"
	
func change_colors(bg_color, bdr_color, txt_color):
	#color = bg_color
	set_style(stylebox_panel, bg_color, bdr_color)
	get_node("Score").add_theme_color_override("font_color", txt_color)

func set_style(style, bg_color, bdr_color):
	# styles are differentated by colors
	style.bg_color = bg_color
	style.border_color = bdr_color
	
	# outline shape is the same for all buttons
	style.border_width_top = 5
	style.border_width_bottom = 5
	style.border_width_left = 5
	style.border_width_right = 5
	style.corner_radius_bottom_left = 5
	style.corner_radius_bottom_right = 5
	style.corner_radius_top_left = 5
	style.corner_radius_top_right = 5
