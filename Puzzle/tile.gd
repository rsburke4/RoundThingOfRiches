extends ColorRect

@export var State = TileConst.STATE_EMPTY

# Called when the node enters the scene tree for the first time.
func _ready():
	# format as an empty tile by default
	change_state(State)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func change_state(state, letter := ""):
	# this state machine enforces some directionality to prevent tile states from changing
	# inappropriately. this was found to be needed when resetting the puzzle board as
	# random tiles sometimes "revealed" wrongly when checking a guess during testing,
	# which stopped happening after the changes
	if state == TileConst.STATE_EMPTY:
		# format for an emtpy tile
		color = TileConst.COLOR_TILE_EMPTY
		get_node("Letter").text = letter		
		get_node("Letter").visible_characters = 0
	elif state == TileConst.STATE_HIDDEN && State == TileConst.STATE_EMPTY:
		# format for a tile hiding a letter
		color = TileConst.COLOR_TILE_LIT
		get_node("Letter").text = letter
		get_node("Letter").visible_characters = 0
	elif state == TileConst.STATE_HIGHLIGHT && State == TileConst.STATE_HIDDEN:
		# format for a tile about to display a letter
		# note it is assumed the letter has already been set, so we only need to change the color
		color = TileConst.COLOR_TILE_HILITE
	elif state == TileConst.STATE_SHOW && State == TileConst.STATE_HIGHLIGHT:
		# format for a tile revealing a letter
		# note it is assumed the letter has already been set
		color = TileConst.COLOR_TILE_LIT
		get_node("Letter").visible_characters = 1
	elif state == TileConst.STATE_BKGD:
		# format to match the background color
		color = Color(TileConst.COLOR_TILE_BKGD, 0)  # this makes it transparent
		
	State = state

func letter_found():
	# if the letter is found, highlight the tile and start the timer
	print("letter found")
	change_state(TileConst.STATE_HIGHLIGHT)
	$RevealTimer.start()
	

func _on_reveal_timer_timeout():
	# when the timer times out, reveal the letter
	change_state(TileConst.STATE_SHOW)
	#pass
