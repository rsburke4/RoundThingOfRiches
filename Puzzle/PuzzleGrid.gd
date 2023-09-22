extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	var tile = preload("res://Puzzle/tile.tscn")
	for c in get_children():
		for i in range(14):
			var tile_i = tile.instantiate()
			tile_i.change_state(TileConst.STATE_EMPTY)  # make sure the state is empty

			# change the corner tiles to match the background color (these aren't used)
			if c.name == "Line1Grid" or c.name == "Line4Grid":
				if i == 0 or i == 13:
					tile_i.change_state(TileConst.STATE_BKGD)
			
			tile_i.name = "Tile" + str(i)
			
			c.add_child(tile_i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
