extends Node2D

# TODO - create sonsolidated file containing all state enums?
enum game {CONFIG, SETUP, PLAYING, END}
enum round {START, PLAYING, END}
enum turn {START, SPIN, GUESS, SOLVE, CONSONANT, VOWeL, END}

var total_scores = []
var round_scores = []
var current_round = 0
var current_player = 0
var num_rounds = 3  # use a placeholder here until needed layers are ready
var num_players = 3

var GameState = game.CONFIG
var RoundState = round.END
var TurnState = turn.END

# Called when the node enters the scene tree for the first time.
func _ready():
	# get nodes for making connections
	var puzzle = get_node("Puzzle")
	var tracker = get_node("GameControl/GuessTracker")
	var solve = get_node("GameControl/SolveButton")
	var wheel = get_node("WheelRoot/WheelPhysics")
	
	## connect game control and puzzle
	tracker.make_a_guess.connect(puzzle._on_guess_made)  # guess a letter
	solve.solve_the_puzzle.connect(puzzle._on_solve_attempt)  # try to solve puzzle
	solve.cancel_solve.connect(puzzle._on_solve_cancelled)  # cancel solve and guess instead
	
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
	
	## connect the wheel to the main scene
	wheel.landed_on_value.connect(_on_wheel_stopped)
	wheel.connect_puzzle(puzzle.get_path())
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_new_game():
	# prevent anything accidentally resetting the game if not coming from configuration state
	if GameState == game.CONFIG:
		GameState = game.SETUP
		
		# reset scores and round
		current_round = 0
		current_player = 0
		
		total_scores = []
		round_scores = []
		
		for p in range(num_players):
			total_scores.append(0)
			round_scores.append(0)
			
		# TODO - reset/reconfigure scores component (function call to component)
		
		start_new_round()
		
func start_new_round():
	# prevent starting a new round unless setting up a new game, or a previous round has ended
	if GameState == game.SETUP or (GameState == game.PLAYING and RoundState == round.END):
		GameState = game.PLAYING
		RoundState = round.START
		
		# setup the new round/puzzle
		current_player = current_round % num_players  # player 1 starts round 1, etc...with cycling in case num_round > num_players
		
		for p in range(num_players):
			round_scores[p] = 0
		
		get_node("Puzzle").create_new_puzzle()
		
		# hide title screen, end round screen
		# show start round screen: text = "Round " + current_round
		# TODO - adjust timer as needed
		await get_tree().create_timer(1.0).timeout
		
		start_turn()
		
func start_turn():
	pass
	
func end_round():
	if GameState == game.PLAYING and RoundState == round.PLAYING and TurnState == turn.END:
		RoundState = round.END
		
		total_scores[current_player] = round_scores[current_player]  # update the score for winning player
		# round scores are updated in start_new_round()
		
		# hide gameplay screen
		# show end round screen: text = "Player " + current_player + " wins Round " + current_round "!"
		# TODO - adjust timer as needed
		await get_tree().create_timer(1.0).timeout
		
		current_round+=1
		if current_round == num_rounds:
			end_game()
		else:
			start_new_round()

func end_game():
	if GameState == game.PLAYING and RoundState == round.END and TurnState == turn.END:
		GameState == game.END
		
		var winner = total_scores.find(total_scores.max()) + 1  # +1 to make it 1-based instead of 0-based
		
		# hide end round screen
		# show game over screen: text = "Game Over: Player " + winner + " wins!"

# TODO - connect to new game button
func new_game_pressed():
	start_new_game()
	
func _on_wheel_stopped(value):
	print("The value of the wheel is: " + str(value))

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
	
	TurnState = turn.END
	
	end_round()
