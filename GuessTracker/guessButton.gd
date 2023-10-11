extends Button

signal guess_a_letter(g)

# define styleboxes here for now to enable easier adjustmest through constants
# duplicate the default styles so only this element is affected, not the entire project
var stylebox_active = get_theme_stylebox("normal").duplicate()
var stylebox_hidden = get_theme_stylebox("pressed").duplicate()
var stylebox_disabled = get_theme_stylebox("disabled").duplicate()
var stylebox_hovered = get_theme_stylebox("hover").duplicate()

# Called when the node enters the scene tree for the first time.
func _ready():
	# set the styles
	# adapted from https://www.reddit.com/r/godot/comments/12zh2qq/godot_40_why_wont_my_ui_panel_stylebox_overwrite/
	set_style(stylebox_active, Colors.COLOR_BUTTON_ACTiVE_BKGD, Colors.COLOR_BUTTON_ACTIVE_BORDER)
	set_style(stylebox_hidden, Colors.COLOR_HIDDEN, Colors.COLOR_HIDDEN)
	set_style(stylebox_disabled, Colors.COLOR_BUTTON_DISABLED_BKGD, Colors.COLOR_BUTTON_DISABLED_BORDER)
	set_style(stylebox_hovered, Colors.COLOR_BUTTON_HOVERED_BKGD, Colors.COLOR_BUTTON_HOVERED_BORDER)
	
	add_theme_color_override("font_color", Colors.COLOR_BUTTON_ACTIVE_TEXT)
	add_theme_color_override("font_disabled_color", Colors.COLOR_BUTTON_DISABLED_TEXT)
	add_theme_color_override("font_hover_color", Colors.COLOR_BUTTON_HOVERED_TEXT)
	
	add_theme_stylebox_override("normal", stylebox_active)
	add_theme_stylebox_override("pressed", stylebox_hidden)
	add_theme_stylebox_override("disabled", stylebox_disabled)
	add_theme_stylebox_override("hover", stylebox_hovered)
	
	reset_button()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
	if not disabled:
		text = ""
	button_mask = 0  # prevent the hidden button from responding to stray clicks

func show_button():
	set_pressed_no_signal(false)
	if not disabled:
		text = name
	button_mask = MOUSE_BUTTON_MASK_LEFT

func _on_pressed():
	disabled = true
	
	guess_a_letter.emit(text)  # emit the signal and send the letter guess to the connected function
