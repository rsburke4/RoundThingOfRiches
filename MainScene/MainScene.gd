extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	## connect guess tracker and puzzle
	# guess a letter
	var puzzle = get_node("Puzzle")
	var tracker = get_node("GameControl/GuessTracker")
	var solve = get_node("GameControl/SolveButton")
	var wheel = get_node("WheelRoot/WheelPhysics")
	
	tracker.make_a_guess.connect(puzzle._on_guess_made)

	# try to solve puzzle
	var submit = get_node("GameControl/SolveButton")
	
	submit.solve_the_puzzle.connect(puzzle._on_solve_attempt)
	submit.cancel_solve.connect(puzzle._on_solve_cancelled)
	
	# manage guess buttons in special game cases (only vowels/consonants left to guess)
	puzzle.only_vowels.connect(tracker.only_vowels)
	puzzle.only_consonants.connect(tracker.only_consonants)
	
	# reset the buttons when the round is over
	puzzle.round_over.connect(tracker.reset_tracker)
	
	puzzle.wrong_solution.connect(solve._on_wrong_guess)
	
	## connect puzzle with main scene
	# TODO - change connections if/when needed during gameflow implementation
	puzzle.guess_complete.connect(_on_guess_complete)
	puzzle.round_over.connect(_on_round_over)
	
	#connect the wheel to the main scene
	wheel.landed_on_value.connect(_on_wheel_stopped)
	wheel.connect_puzzle(puzzle.get_path())
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_guess_complete(c,g):
	if c == 0:
		print("Incorrect guess. Next player's turn.")
	else:
		print("Count of letter " + g + ": " + str(c))
		
		if g in ["A","E","I","O","U"]:
			print("Vowel guessed")
			c = 1
			# TODO - handle scoring for vowels
	
func _on_round_over():
	print("Puzzle successfully solved!")
	
func _on_wheel_stopped(value):
	print("The value of the wheel is: " + str(value))
	

