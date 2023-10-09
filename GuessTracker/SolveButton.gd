extends Button

signal solve_the_puzzle
signal cancel_solve

# define styleboxes here for now to enable easier adjustmest through constants (if needed later)
var stylebox_active = get_theme_stylebox("normal").duplicate()
var stylebox_pressed = get_theme_stylebox("pressed").duplicate()
var stylebox_disabled = get_theme_stylebox("disabled").duplicate()
var stylebox_hovered = get_theme_stylebox("hover").duplicate()

# Called when the node enters the scene tree for the first time.
func _ready():
	# button states are to be used as follows:
	#  * Normal = default appearance when player is able to opt to solve
	#  * Pressed = appearance when playing is trying to solve, click again to cancel solve
	#  * Hover = appearance when unpressed and mouse is hovering
	#  * Hover Pressed = appearance when pressed and mouse is hovering
	#  * Disabled = button is hidden when player cannot opt to sovle (e.g. before spinning)
	
	# programatcally set the apperance using constants
	# adapted from https://www.reddit.com/r/godot/comments/12zh2qq/godot_40_why_wont_my_ui_panel_stylebox_overwrite/
	set_style(stylebox_active, Colors.COLOR_SOLVE_BTN_ACTiVE_BKGD, Colors.COLOR_SOLVE_BTN_ACTIVE_BORDER)
	set_style(stylebox_disabled, Colors.COLOR_HIDDEN, Colors.COLOR_HIDDEN)
	set_style(stylebox_pressed, Colors.COLOR_SOLVE_BTN_PRESSED_BKGD, Colors.COLOR_SOLVE_BTN_PRESSED_BORDER)
	set_style(stylebox_hovered, Colors.COLOR_SOLVE_BTN_HOVERED_BKGD, Colors.COLOR_SOLVE_BTN_HOVERED_BORDER)
	
	add_theme_color_override("font_color", Colors.COLOR_SOLVE_BTN_ACTIVE_TEXT)
	add_theme_color_override("font_disabled_color", Colors.COLOR_HIDDEN)
	add_theme_color_override("font_pressed_color", Colors.COLOR_SOLVE_BTN_PRESSED_TEXT)
	add_theme_color_override("font_hover_color", Colors.COLOR_SOLVE_BTN_HOVERED_TEXT)
	
	add_theme_stylebox_override("normal", stylebox_active)
	add_theme_stylebox_override("pressed", stylebox_pressed)
	add_theme_stylebox_override("disabled", stylebox_disabled)
	add_theme_stylebox_override("hover", stylebox_hovered)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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

func reset_button():
	button_pressed = false

func _on_toggled(is_button_pressed):
	if is_button_pressed:
		solve_the_puzzle.emit()
		text = "Cancel"
	else:
		cancel_solve.emit()
		text = "SOLVE"

func _on_wrong_guess():
	button_pressed = false
