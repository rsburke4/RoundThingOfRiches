extends Button

# define styleboxes here for now to enable easier adjustmest through constants (if needed later)
var stylebox_active = get_theme_stylebox("normal").duplicate()
var stylebox_hidden = get_theme_stylebox("pressed").duplicate()
var stylebox_disabled = get_theme_stylebox("disabled").duplicate()
# TODO - set styles for hover; add other theme overrides (font size, color, etc) as necessary

# Called when the node enters the scene tree for the first time.
func _ready():
	# set the styles
	# adapted from https://www.reddit.com/r/godot/comments/12zh2qq/godot_40_why_wont_my_ui_panel_stylebox_overwrite/
	set_style(stylebox_active, GuessConst.COLOR_BUTTON_ACTiVE_BKGD, GuessConst.COLOR_BUTTON_ACTIVE_BORDER)
	set_style(stylebox_hidden, GuessConst.COLOR_BUTTON_HIDDEN, GuessConst.COLOR_BUTTON_HIDDEN)
	set_style(stylebox_disabled, GuessConst.COLOR_BUTTON_DISABLED_BKGD, GuessConst.COLOR_BUTTON_DISABLED_BORDER)
	
	add_theme_stylebox_override("normal", stylebox_active)
	add_theme_stylebox_override("pressed", stylebox_hidden)
	add_theme_stylebox_override("disabled", stylebox_disabled)
	
	reset_button()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reset_button():
	disabled = false

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

func hide_button():
	toggle_mode = true  # needed to set the state of the button
	set_pressed_no_signal(true)  # per tool tip, this is used to set the state without emitting signal
	
	button_mask = 0  # prevent the hidden button from responding to stray clicks

func _on_pressed():
	print(text)
	
	disabled = true
