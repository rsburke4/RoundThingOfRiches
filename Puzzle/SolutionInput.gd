extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var textbox = get_node("SolutionGuess")
	var submit = get_node("SolutionSubmit")

	# format the text box
	var stylebox_normal = textbox.get_theme_stylebox("normal").duplicate()
	var stylebox_focus = textbox.get_theme_stylebox("focus").duplicate()
	
	set_style(stylebox_normal, Colors.COLOR_SOLVE_BTN_PRESSED_BKGD, Colors.COLOR_SOLVE_BTN_PRESSED_BORDER)
	set_style(stylebox_focus, Colors.COLOR_HIDDEN, Colors.COLOR_SOLVE_BTN_HOVERED_BORDER)
	
	textbox.set("theme_override_colors/font_color", Colors.COLOR_SOLVE_BTN_PRESSED_TEXT)
	textbox.set("theme_override_colors/font_selected_color", Colors.COLOR_SOLVE_BTN_HOVERED_BKGD)
	textbox.set("theme_override_colors/font_placeholder_color", Colors.COLOR_SOLVE_BTN_HOVERED_TEXT)
	textbox.set("theme_override_colors/caret_color", Colors.COLOR_SOLVE_BTN_HOVERED_TEXT)
	textbox.set("theme_override_colors/selection_color", Colors.COLOR_SOLVE_BTN_HOVERED_TEXT)
	
	textbox.add_theme_stylebox_override("normal", stylebox_normal)
	textbox.add_theme_stylebox_override("focux", stylebox_focus)
	
	# format the submit button
	var stylebox_active = submit.get_theme_stylebox("normal").duplicate()
	var stylebox_pressed = submit.get_theme_stylebox("pressed").duplicate()
	var stylebox_hovered = submit.get_theme_stylebox("hover").duplicate()

	set_style(stylebox_active, Colors.COLOR_SOLVE_BTN_ACTiVE_BKGD, Colors.COLOR_SOLVE_BTN_ACTIVE_BORDER)
	set_style(stylebox_pressed, Colors.COLOR_SOLVE_BTN_PRESSED_BKGD, Colors.COLOR_SOLVE_BTN_PRESSED_BORDER)
	set_style(stylebox_hovered, Colors.COLOR_SOLVE_BTN_HOVERED_BKGD, Colors.COLOR_SOLVE_BTN_HOVERED_BORDER)
	
	submit.add_theme_color_override("font_color", Colors.COLOR_SOLVE_BTN_ACTIVE_TEXT)
	submit.add_theme_color_override("font_pressed_color", Colors.COLOR_SOLVE_BTN_PRESSED_TEXT)
	submit.add_theme_color_override("font_hover_color", Colors.COLOR_SOLVE_BTN_HOVERED_TEXT)
	
	submit.add_theme_stylebox_override("normal", stylebox_active)
	submit.add_theme_stylebox_override("pressed", stylebox_pressed)
	submit.add_theme_stylebox_override("hover", stylebox_hovered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_style(style, bg_color, bdr_color):
	# styles are differentated by colors
	style.bg_color = bg_color
	style.border_color = bdr_color
	
	# outline shape is the same for all buttons
	style.border_width_top = 3
	style.border_width_bottom = 3
	style.border_width_left = 3
	style.border_width_right = 3
	style.corner_radius_bottom_left = 5
	style.corner_radius_bottom_right = 5
	style.corner_radius_top_left = 5
	style.corner_radius_top_right = 5

# TODO - any other methods needed for formatting?
