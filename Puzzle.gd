extends Node2D

# globals - but does these make sense to be global?
var new_puzzle

# JSON parsing based off example in Godot documentation:
# https://docs.godotengine.org/en/stable/classes/class_json.html
var json = JSON.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# any formatting...
	get_node("Background").color = TileConst.COLOR_TILE_BKGD
	
	new_puzzle = get_puzzle("res://answers.json")
	var category = get_node("Category")
	
	# initialize the puzzle
	# TODO - move this to a separate function to be called each new round
	category.text = new_puzzle.Category
	setup_puzzle(new_puzzle)  # is this argument necessary? would this ever be called without the global?


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_puzzle(filename):
	var puzzle_dict = {"Category": "", "NumLines": 0, "Line1": "","Line2": "", "Line3": "","Line4": ""}
	
	# TODO - check for file existence
	var raw_data = FileAccess.get_file_as_string(filename)
	var all_answers = json.parse_string(raw_data)
	
	# do some manipulation to select a random puzzle
	#   (1) Don't let the selected answer be element [0], which is the heading of the table
	#   (2) Modulo (size - 1) will all access from first to penultimate element
	#   (3) Adding 1 will allow access from second to last element
	var answer_count = all_answers.size() - 1
	var selected_answer = all_answers[(randi() % answer_count) + 1]
	
	# this assumes each entry of the JSON file is an array of the format:
	# [ round, category, [lines up to 4]]
	# probably could better generalize this by processing the first element, which contains these headings
	puzzle_dict.Category = selected_answer[1]
	puzzle_dict.NumLines = selected_answer.size() - 2
	
	# read into the dictionary based on number of lines so it appears "centered"
	# vertically on the grid
	#  > 1-line will be on line 2
	#  > 2-lines will be on lines 2 and 3
	#  > 3-lines will be on lines 2 through 4
	#  > 4-lines will be on lines 1 through 4
	if puzzle_dict.NumLines == 4:  # this is the only case that will use Line1
		print("in if")
		puzzle_dict.Line1 = selected_answer[2]
		puzzle_dict.Line2 = selected_answer[3]
		puzzle_dict.Line3 = selected_answer[4]
		puzzle_dict.Line4 = selected_answer[5]
	else:  # the only caution here is to not overrrun the number of lines
		puzzle_dict.Line2 = selected_answer[2]
		if puzzle_dict.NumLines >= 2: puzzle_dict.Line3 = selected_answer[3]
		if puzzle_dict.NumLines >= 3: puzzle_dict.Line4 = selected_answer[4]

	return puzzle_dict;

func setup_puzzle(puzzle):
	print(puzzle.Line1)
	print(puzzle.Line2)
	print(puzzle.Line3)
	print(puzzle.Line4)
	
	# get nodes for each line for easier access of children
	var line1 = get_node("PuzzleGrid/Line1Grid")
	var line2 = get_node("PuzzleGrid/Line2Grid")
	var line3 = get_node("PuzzleGrid/Line3Grid")
	var line4 = get_node("PuzzleGrid/Line4Grid")
	
	# for each line, need to find the first and last tiles to be used so that
	# text is as close to centered as possible
	for l in [line1, line2, line3, line4]:
		var label = l.name.substr(0,5)  # this will get "LineX"
		var cur_line = puzzle[label]

# TODO - need to account for extra padding on lines 1 and 4
		if cur_line.length() > 0:
			# need to do padding differently for lines 1 and 4
			var padding
			var start
			var end
			if label in ["Line1", "Line4"]:
				# this only has 12 open spaces and starts/stops "one in" from the other lines
				padding = (12-cur_line.length())/2.0
				start = floor(padding) + 1
				end = 14 - ceil(padding) - 1 
			else:
				padding = (14-cur_line.length())/2.0  # number of blanks on either side
				start = floor(padding)
				end = 14 - ceil(padding)  # this will pad more to the end if there's an odd number

			var tiles = range(start,end)

			for i in range(cur_line.length()):
				if cur_line[i] != " ":
					var tile = l.get_node("Tile"+str(tiles[i]))
					tile.change_state(TileConst.STATE_HIDDEN, cur_line[i])
