extends Button

signal solve_the_puzzle
signal cancel_solve

# define styleboxes here for now to enable easier adjustmest through constants (if needed later)
var stylebox_active = get_theme_stylebox("normal").duplicate()
var stylebox_hidden = get_theme_stylebox("pressed").duplicate()
var stylebox_disabled = get_theme_stylebox("disabled").duplicate()
# TODO - set styles for hover; add other theme overrides (font size, color, etc) as necessary

# Called when the node enters the scene tree for the first time.
func _ready():
	# programatcally set the apperance using constants
	# adapted from https://www.reddit.com/r/godot/comments/12zh2qq/godot_40_why_wont_my_ui_panel_stylebox_overwrite/
	set_style(stylebox_active, SolveConst.COLOR_SOLVE_BTN_ACTiVE_BKGD, SolveConst.COLOR_SOLVE_BTN_ACTIVE_BORDER)
	set_style(stylebox_hidden, SolveConst.COLOR_BUTTON_HIDDEN, SolveConst.COLOR_BUTTON_HIDDEN)
	set_style(stylebox_disabled, SolveConst.COLOR_SOLVE_BTN_DISABLED_BKGD, SolveConst.COLOR_SOLVE_BTN_DISABLED_BORDER)

	add_theme_stylebox_override("normal", stylebox_active)
	add_theme_stylebox_override("pressed", stylebox_hidden)
	add_theme_stylebox_override("disabled", stylebox_disabled)

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
	else:
		cancel_solve.emit()

func _on_wrong_guess():
	button_pressed = false
