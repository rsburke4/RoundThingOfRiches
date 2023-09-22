extends ColorRect

@export var State = TileConst.STATE_EMPTY

# Called when the node enters the scene tree for the first time.
func _ready():
	# format as an empty tile by default
	change_state(State)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_state(state, letter := "", bkgd := Color(1,1,1,1)):
	State = state
	if state == TileConst.STATE_EMPTY:
		# format for an emtpy tile
		color = TileConst.COLOR_TILE_EMPTY
		get_node("Letter").visible_characters = 0		
	elif state == TileConst.STATE_HIDDEN:
		# format for a tile hiding a letter
		color = TileConst.COLOR_TILE_LIT
		get_node("Letter").text = letter
	elif state == TileConst.STATE_HIGHLIGHT:
		# format for a tile about to display a letter
		# note it is assumed the letter has already been set, so we only need to change the color
		color = TileConst.COLOR_TILE_HILITE
	elif state == TileConst.STATE_SHOW:
		# format for a tile revealing a letter
		# note it is assumed the letter has already been set
		color = TileConst.COLOR_TILE_LIT
		get_node("Letter").visible_characters = 1
	elif state == TileConst.STATE_BKGD:
		# format to match the background color
		color = TileConst.COLOR_TILE_BKGD
