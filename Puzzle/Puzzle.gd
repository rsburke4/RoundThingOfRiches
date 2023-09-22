extends Node2D

@export var State = PuzzleConst.STATE_EMPTY

# globals used until it is determined if they should be globals or not
var guess = ""
var guesses = [""]
var tiles_used = [[0,0],[0,0],[0,0],[0,0]]  # will hold the first and last tiles used for the puzzle
var rem_guesses = 0  # will hold the total number of letters in the answer

# JSON parsing based off example in Godot documentation:
# https://docs.godotengine.org/en/stable/classes/class_json.html
var json = JSON.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# any formatting...
	get_node("Background").color = TileConst.COLOR_TILE_BKGD

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var tiles_used = [[0,0],[0,0],[0,0],[0,0]]  # will hold the first and last tiles used for the puzzle
	# as a test, create a new puzzle when the screen is clicked
	# TODO - replace this with signals, as appropriate, during integration steps
	# The second condition prevents resetting the puzzle in the middle of a game
	if Input.is_action_just_pressed("enter_press") and State in [PuzzleConst.STATE_EMPTY, PuzzleConst.STATE_GAMEOVER]:
		tiles_used = create_new_puzzle()
		State = PuzzleConst.STATE_PLAYING
	
	# TODO - add searching for letters
	# Only do this while in "playing" state
	if not (guess in guesses) and State == PuzzleConst.STATE_PLAYING:
		var count = evaluate_guess(guess, tiles_used)
		print("Count of letter " + guess + " found = " + str(count))
		guesses.append(guess)
		
		if rem_guesses == 0:
			State = PuzzleConst.STATE_GAMEOVER
	
# TODO - this can be replaced with signals from clicking on the letter grid, which
# may be more reliable and cleaner...
func _input(event):
	# scan code enumerations found from:
	# https://docs.godotengine.org/en/3.0/classes/class_@globalscope.html?highlight=Global_scope
	# here A = 65 and Z = 90, so it iwll only detect letter key presses
	if event is InputEventKey and event.keycode >= 65 and event.keycode <= 90:
		# getting letter is based on example in documentation:
		# https://docs.godotengine.org/en/stable/classes/class_inputeventkey.html
		guess = OS.get_keycode_string(event.key_label)
		
func create_new_puzzle():
	reset_puzzle()
	var new_puzzle = get_puzzle("res://answers.json")
	var category = get_node("Category")
	
	category.text = new_puzzle.Category
	return setup_puzzle(new_puzzle)

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
	
	var loc = [ [0, 0], [0, 0], [0, 0], [0, 0]]
	
	# for each line, need to find the first and last tiles to be used so that
	# text is as close to centered as possible
	for l in [line1, line2, line3, line4]:
		var label = l.name.substr(0,5)  # this will get "LineX"
		var cur_line = puzzle[label]

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
				
			loc[label[label.length()-1].to_int()-1] = [start, end]

			var tiles = range(start,end)

			for i in range(cur_line.length()):
				if cur_line[i] != " ":
					var tile = l.get_node("Tile"+str(tiles[i]))
					tile.change_state(TileConst.STATE_HIDDEN, cur_line[i])
					
					# show any punctuation that may be used
					if cur_line[i] in ["-", "'"]:
						tile.change_state(TileConst.STATE_HIGHLIGHT)
						tile.change_state(TileConst.STATE_SHOW)
					else:
						rem_guesses+=1  # increase this for each (letter) tile added

	return loc

func reset_puzzle():
	# loop through all tiles and reset states
	for l in range(1,5):
		var grid = get_node("PuzzleGrid/Line" + str(l) + "Grid")  # get the line
		
		for t in range(14):
			var tile = grid.get_node("Tile" + str(t))  # get the tile
			if (l == 1 or l ==4) and (t == 0 or t == 13):
				tile.change_state(TileConst.STATE_BKGD)  # make sure to keep these background color
			else:
				tile.change_state(TileConst.STATE_EMPTY)  # this should reset color AND text

func evaluate_guess(c, ind):
	var count = 0
	
	for l in range(1,5):  # for each line (1 to 4)...
		if ind[l-1][1]-ind[l-1][0] > 0:  # if the line contains letters...
			var grid = get_node("PuzzleGrid/Line" + str(l) + "Grid");  # get the line from the grid

			for t in range(ind[l-1][0], ind[l-1][1]):  # check each tile with letters...
				# note this works with range() bc ind[l][1] is 1+ last tile loc
				var tile = grid.get_node("Tile" + str(t))  # get the tile from the line
				var letter = tile.get_node("Letter").text

				if c.to_upper() == letter.to_upper():
					tile.letter_found()
					count+=1
					rem_guesses-=1  # reduce the number of guesses by one for each tile turned
				else:
					get_node("Background").color = Color.DARK_RED
					$WrongGuessTimer.start()
					# use timer to change background briefly as notification
					# TODO - if this indication stays, also change the first and last tiles in rows 1 and 4

	return count

func _on_wrong_guess_timer_timeout():
	get_node("Background").color = TileConst.COLOR_TILE_BKGD # reset background color
	# TODO - if this indication stays, also change the first and last tines in rows 1 and 4
