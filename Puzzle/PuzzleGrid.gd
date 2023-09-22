extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	var tile = preload("res://Puzzle/tile.tscn")
	for c in get_children():
		for i in range(14):
			var tile_i = tile.instantiate()
			var letter = tile_i.get_node("Letter")
						
			# format
			letter.text = "A"
			letter.visible_characters = 0
			
			tile_i.color = Color.SEA_GREEN
			
			if c.name == "Line1Grid" or c.name == "Line4Grid":
				if i == 0 or i == 13:
					tile_i.color = get_parent().get_node("Background").color
			
			tile_i.name = "Tile " + str(i)
			
			c.add_child(tile_i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
