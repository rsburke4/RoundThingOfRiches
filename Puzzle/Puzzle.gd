extends Node2D

@export var State = PuzzleConst.STATE_EMPTY

signal guess_complete(count,guess)
signal round_over

# globals used until it is determined if they should be globals or not
var guesses = []
var puzzles_used = []  # used to prevent using same puzzle in a game
var puzzles_skipped = []
var tiles_used = [[0,0],[0,0],[0,0],[0,0]]  # will hold the first and last tiles used for the puzzle
var rem_guesses = 0  # will hold the total number of letters in the answer
var solution = ""  # will hold the solution as a single line

# JSON parsing based off example in Godot documentation:
# https://docs.godotengine.org/en/stable/classes/class_json.html
var json = JSON.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# any formatting...
	get_node("Background").color = TileConst.COLOR_TILE_BKGD
	
	# hide the solution panel
	get_node("SolutionInput").hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# as a test, create a new puzzle when the screen is clicked
	# TODO - replace this with signals, as appropriate, during integration steps
	# The second condition prevents resetting the puzzle in the middle of a game
	if Input.is_action_just_pressed("enter_press") and State in [PuzzleConst.STATE_EMPTY, PuzzleConst.STATE_GAMEOVER]:
		tiles_used = create_new_puzzle()
		State = PuzzleConst.STATE_PLAYING
		
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
	var reroll = true
	var answer_count = all_answers.size() - 1
	var selected_answer
	var puzzle_index
		
	while reroll:
		puzzle_index = (randi() % answer_count) + 1
		selected_answer = all_answers[puzzle_index]
		
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
			puzzle_dict.Line1 = selected_answer[2].to_upper()
			puzzle_dict.Line2 = selected_answer[3].to_upper()
			puzzle_dict.Line3 = selected_answer[4].to_upper()
			puzzle_dict.Line4 = selected_answer[5].to_upper()
		else:  # the only caution here is to not overrrun the number of lines
			puzzle_dict.Line2 = selected_answer[2].to_upper()
			if puzzle_dict.NumLines >= 2: puzzle_dict.Line3 = selected_answer[3].to_upper()
			if puzzle_dict.NumLines >= 3: puzzle_dict.Line4 = selected_answer[4].to_upper()
			
		reroll = puzzle_dict.Line1.length() > 12 or puzzle_dict.Line2.length() > 14 or \
			puzzle_dict.Line3.length() > 14 or puzzle_dict.Line4.length() > 12 or \
			(puzzle_index in puzzles_used) or (puzzle_index in puzzles_skipped)
			
		# bookkeeping to track skipped puzzles and reset the dict to avoid stray words
		if reroll:
			puzzles_skipped.append(puzzle_index)  # collect indices of all puzzles which won't fit grid (or have already been used)

			# reset the solution in the dict
			puzzle_dict.Line1 = ""
			puzzle_dict.Line2 = ""
			puzzle_dict.Line3 = ""
			puzzle_dict.Line4 = ""
			
		# reset puzzle trackers if all puzzles have been used or skipped
		if reroll and (puzzle_index in puzzles_used) and (puzzle_index in puzzles_skipped):
			puzzles_used = []
			puzzles_skipped = []
			
	puzzles_used.append(puzzle_index)

	solution = puzzle_dict.Line1 + " " + puzzle_dict.Line2 + " " + puzzle_dict.Line3 + " " + puzzle_dict.Line4
	solution = solution.strip_edges()  # get rid of leading, traiiling spaces

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
	
	var loc = [ [0, 0], [0, 0], [0, 0], [0, 0] ]  # reset ranges for each new puzzle
	rem_guesses = 0  # reset this counter for each new puzzle
	
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
					if cur_line[i] in ["-", "'", "&"]:
						tile.change_state(TileConst.STATE_HIGHLIGHT)
						tile.change_state(TileConst.STATE_SHOW)
					else:
						rem_guesses+=1  # increase this for each (letter) tile added

	return loc

func reset_puzzle():
	# reset the category
	get_node("Category").text = ""
	
	guesses = []  # reset the list of guesses so it doesn't carry over round-to-round
	
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
					
	if count == 0:
		get_node("Background").color = Color.DARK_RED
		$WrongGuessTimer.start()
		# use timer to change background briefly as notification

	return count

func _on_guess_made(g):
	# Only do this while in "playing" state
	if not (g in guesses) and State == PuzzleConst.STATE_PLAYING and State != PuzzleConst.STATE_SOLVE:
		var count = evaluate_guess(g, tiles_used)
		guesses.append(g)
		
		if rem_guesses == 0:
			State = PuzzleConst.STATE_GAMEOVER
			
		guess_complete.emit(count,g)

func _on_wrong_guess_timer_timeout():
	get_node("Background").color = TileConst.COLOR_TILE_BKGD # reset background color
	# TODO - if this indication stays, also change the first and last tines in rows 1 and 4

func _on_solve_attempt():
	print("solve the puzzle!")
	if State == PuzzleConst.STATE_PLAYING:
		get_node("SolutionInput").show()
		State = PuzzleConst.STATE_SOLVE

func _on_solve_cancelled():
	print("changed my mind!")
	if State == PuzzleConst.STATE_SOLVE:
		get_node("SolutionInput").hide()
		State = PuzzleConst.STATE_PLAYING

func _on_solution_submit_pressed():
	print("Made a guess!")
	
	var input_box = get_node("SolutionInput/SolutionGuess")
	var guess = input_box.text.to_upper()
	
	var isRoundOver = guess.matchn(solution)
	
	if isRoundOver:
		State = PuzzleConst.STATE_GAMEOVER
		input_box.text = ""
		round_over.emit()
		reset_puzzle()
	else:
		State = PuzzleConst.STATE_PLAYING
		input_box.text = ""
		print("Try again!")
		guess_complete.emit(0)  # if the guess is wrong, turn moves to next player with no points awarded
	
	get_node("SolutionInput").hide()  # TODO - consider a state machine function
