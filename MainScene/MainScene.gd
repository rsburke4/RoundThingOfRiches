extends Node2D

signal game_over

var total_scores = []
var round_scores = []
var current_round = 0
var current_player = 0
var num_rounds = 3  # use a placeholder here until needed layers are ready
var num_players = 3
var guess_score = 0
var can_spin = false

var GameState = States.game.CONFIG
var RoundState = States.puzzle_round.END
var TurnState = States.turn.END
var TurnState_prev  # only used when attempting to solve

# Called when the node enters the scene tree for the first time.
func _ready():
	# get nodes for making connections
	var puzzle = get_node("Puzzle")
	var tracker = get_node("GameControl/GuessTracker")
	var solve = get_node("GameControl/SolveButton")
	var wheel = get_node("SubViewport/WheelRoot/WheelPhysics")
	
	## connect game control and puzzle
	tracker.make_a_guess.connect(puzzle._on_guess_made)  # guess a letter
	solve.solve_the_puzzle.connect(puzzle._on_solve_attempt)  # try to solve puzzle
	solve.cancel_solve.connect(puzzle._on_solve_cancelled)  # cancel solve and guess instead
	
	# manage guess buttons in special game cases (only vowels/consonants left to guess)
	puzzle.only_vowels.connect(tracker.only_vowels)
	puzzle.only_consonants.connect(tracker.only_consonants)
	
	# reset the buttons when the round is over
	puzzle.round_over.connect(tracker.reset_tracker)
	puzzle.round_over.connect(solve.reset_button)
	puzzle.wrong_solution.connect(solve._on_wrong_guess)
	
	## connect puzzle with main scene
	# TODO - change connections if/when needed during gameflow implementation
	puzzle.guess_complete.connect(_on_guess_complete)
	puzzle.round_over.connect(_on_round_over)
	puzzle.only_vowels.connect(_on_only_vowels)
	
	## connect the wheel to the main scene
	wheel.landed_on_value.connect(_on_wheel_stopped)
	wheel.connect_puzzle(puzzle.get_path())
	
	## connect guess tracker (solve button) with main scene
	solve.solve_the_puzzle.connect(_on_solve_attempt)
	solve.cancel_solve.connect(_on_solve_cancelled)
	
	## connect main scene with game over
	game_over.connect(get_node("GameOver")._on_game_over)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

## functions defining gameplay
# defines behavior when the "new game" (title) screen is displayed
func start_new_game():
	# prevent anything accidentally resetting the game if not coming from configuration state
	if GameState == States.game.CONFIG:
		GameState = States.game.SETUP
		
		# reset scores and round
		current_round = 0
		current_player = 0
		
		total_scores = []
		round_scores = []
		guess_score = 0
		
		for p in range(num_players):
			total_scores.append(0)
			round_scores.append(0)
		
		get_node("ScoreBoard").reset_board()
		get_node("ScoreBoard").setup_scores(num_players)
		
		get_node("GameOver").hide()
		# show title screen
		
		# TODO - enable new game button only when # players, # rounds provided

# defines behavior at the start of each round of the game (each new puzzle)
func start_new_round():
	# prevent starting a new round unless setting up a new game, or a previous round has ended
	if GameState == States.game.SETUP or (GameState == States.game.PLAYING and RoundState == States.puzzle_round.END):
		GameState = States.game.PLAYING
		RoundState = States.puzzle_round.START
		
		# setup the new round/puzzle
		current_player = current_round % num_players  # player 1 starts round 1, etc...with cycling in case num_round > num_players
		get_node("ScoreBoard").next_player(current_player+1)
		
		guess_score = 0
		
		for p in range(num_players):
			round_scores[p] = 0
			get_node("ScoreBoard").update_score(p+1, 0)
		
		# here we need to wait for the puzzle grid to be created before setting
		# up th puzzle **for the first round only** -- for subsequent rounds,
		# the grid already exists and can be reset/changed
		if current_round == 0: await get_node("Puzzle/PuzzleGrid").grid_ready
		get_node("Puzzle").start_new_round()
		
		# TODO - remove, this is just for testing
		get_node("Tmp/Label").text = "Round " + str(current_round + 1)
		get_node("Tmp/Announce").text = ""
		show_message("ROUND " + str(current_round + 1))
		
		# hide title screen, end round screen
		get_node("GameControl").show()
		get_node("Puzzle").show()
		get_node("WheelRenderer").show()

		# show start round screen: text = "Round " + current_round
		
		# TODO - adjust timer as needed
		await get_tree().create_timer(1.0).timeout
		
		start_turn()

# defines the behavior at the start of each player's turn (from first spin until
# a wrong letter or solution is guessed, a turn-ending space is landed on, or 
# the puzzle is solved correctly)
func start_turn():
	RoundState = States.puzzle_round.PLAYING
	
	if GameState == States.game.PLAYING and RoundState == States.puzzle_round.PLAYING and TurnState == States.turn.END:
		TurnState = States.turn.START
		
		# TODO - highlight current player in scoring component
		get_node("ScoreBoard").next_player(current_player+1)
		
		# hide start round screen
		# show gameplay screen
		
		get_node("SubViewport/WheelRoot/WheelPhysics").set_spin(false)
		
		turn_state_machine()
		
func turn_state_machine():
	# state machine will be called for many different states of TurnState, so first
	# check that the game and round are both in "playing" state before worrying
	# about the turn state
	var wheel = get_node("SubViewport/WheelRoot/WheelPhysics")
	var tracker = get_node("GameControl")
	var letters = get_node("GameControl/GuessTracker")
	
	if GameState == States.game.PLAYING and RoundState == States.puzzle_round.PLAYING:
		if TurnState == States.turn.START:
			print("State: Turn Start")
			# each turn starts with a spin, so make that possible
			TurnState = States.turn.SPIN
			
			wheel.set_spin(true)
			tracker.hide()  # hide/diable guess tracker
		elif TurnState == States.turn.SPIN:
			print("State: Turn Spin")
			
			# wait for the player to spin and handle in callback
			pass  # handled by wheel
		elif TurnState == States.turn.GUESS:
			print("State: Turn Guess")
			# player must guess a letter or solve
			
			wheel.set_spin(false)
			letters.show_consonants()  # enable/show consonants
			
			if round_scores[current_player] < 250 and guess_score != -2:
				letters.hide_vowels()  # disable/hide vowels if not able to buy one
			else:
				letters.show_vowels()  # otherwise enable/show them
			
			letters.show()  # show tracker letter buttons
			tracker.show()  # show/enable guess tracker
		elif TurnState == States.turn.CORRECT:
			print("State: Turn Post-guess")
			# player must guess a vowel, solve, or spin
			if round_scores[current_player] < 250:
				letters.hide()
			else:
				letters.show_vowels()  # enable/show consonants
				letters.hide_consonants()  # disable/hide consonants
				letters.show()  # show tracker buttons
			
			tracker.show()
			wheel.set_spin(true)
		elif TurnState == States.turn.SOLVE:
			print("State: Solve Attempt")
			# player must enter a solution attempt, or cancel the attempt
			
			wheel.set_spin(false)
			letters.hide()
		elif TurnState == States.turn.END:
			print("State: Turn Over")
			
			current_player = (current_player + 1) % num_players
			
			start_turn()  # start turn for next player (incremented in end_turn())

# defines what happens when a player's turn has ended (play passes to the next player)
func end_turn():
	# turn can only end if game and round states are both "playing" and the turn is
	# in one of the following states: "spinning" (lose-a-turn, bankrupt), "guessing"
	# (wrong guess after a spin), "vowel" (wrong guess after a right guess), or
	# "solving" (wrong solution guessed)
	if GameState == States.game.PLAYING and RoundState == States.puzzle_round.PLAYING and \
		(TurnState in [States.turn.SPIN, States.turn.GUESS, States.turn.CORRECT, States.turn.SOLVE]):
			TurnState = States.turn.END
			
			guess_score = 0
			turn_state_machine()

# defines behavior at the end of a round (puzzle has been solved)
func end_round():
	if GameState == States.game.PLAYING and RoundState == States.puzzle_round.PLAYING and TurnState == States.turn.END:
		RoundState = States.puzzle_round.END
		
		total_scores[current_player] += max(1000, round_scores[current_player])  # update the score for winning player (min score per round = 1000)
		# round scores are reset in start_new_round()
		
		# TODO - remove this, used for testing		
		get_node("Tmp/Announce").text = "Player " + str(current_player + 1) + " wins round!"
		
		# hide gameplay screen
		# show end round screen: text = "Player " + current_player + " wins Round " + current_round "!"
		
		# TODO - adjust timer as needed
		await get_tree().create_timer(1.0).timeout
		
		get_node("Tmp/Announce").text = ""  # TODO - remove after testing is completed
		
		current_round+=1
		if current_round == num_rounds:
			end_game()
		else:
			start_new_round()

# defines behavior once all rounds have been completed (puzzles solved) and a winner decided
func end_game():
	if GameState == States.game.PLAYING and RoundState == States.puzzle_round.END and TurnState == States.turn.END:
		GameState = States.game.END
		
		var max_score = total_scores.max()
		var is_tie = total_scores.count(max_score) > 1
		
		if is_tie:
			var loc = 0
			for i in range(num_players):
				loc = total_scores.find(max_score, loc)
				loc+=1
			
			get_node("Tmp/Announce").text = "There's a tie! Winner take all round"  # TODO - remove when testing is done
			show_message("There's a tie! \nWinner takes all!")
			
			num_players = total_scores.count(max_score)
			num_rounds = 1
			
			GameState = States.game.CONFIG
			
			start_new_game()
			start_new_round()
		else:
			var winner = total_scores.find(max_score) + 1  # +1 to make it 1-based instead of 0-based
		
			get_node("Tmp/Announce").text = "Player " + str(winner) + " wins game!"  # TODO - remove when testing is done
		
			for i in range(num_players):
				get_node("ScoreBoard").update_score(i+1, total_scores[i])
				get_node("ScoreBoard").next_player(winner)
		
			# hide end round screen
			get_node("GameControl").hide()
			get_node("Puzzle").hide()
			get_node("WheelRenderer").hide()
			get_node("GameOver").show()
		
			game_over.emit(winner)

# defines how to update the player's score
func update_score(count, is_vowel):
	if count == -1:  # scoring for "bankrupt"
		round_scores[current_player] = 0
	elif guess_score == -2:  # scoring for "free-play": consonant = 500 (per), vowel = 0
		if not is_vowel:
			round_scores[current_player] += 500 * count
	else:
		if is_vowel:
			round_scores[current_player] -= 250  # lose 250 total when buying vowel
		else:
			round_scores[current_player] += guess_score * count
			
	# TODO - update score in scoring component
	get_node("ScoreBoard").update_score(current_player+1, round_scores[current_player])

## functions connected to built-in signals
# TODO - connect to new game button on game over screen
func play_again_pressed():
	start_new_game()

# TODO - connect to start game button on title screen
func start_game_pressed():
	if GameState in [States.game.END, States.game.CONFIG] and RoundState == States.puzzle_round.END and TurnState == States.turn.END:
		start_new_game()  # TODO - remove this line when testing is done
		start_new_round()
		
func _on_tree_entered():
	start_new_game()
	start_new_round()

## functions connected to custom signals
func _on_wheel_stopped(value):
	if value == -1:  # bankrupt
		# TODO - work on the logic here...
		show_message("Bankrupt")
		update_score(-1, false)
		end_turn()
	elif value == -2:  # free play
		show_message("Free Play")
		TurnState = States.turn.GUESS
		guess_score = -2  # use this in scoring calculation
		turn_state_machine()
		# TODO - work on the logic here...
	elif value == -3:  # lose a turn
		show_message("Lose a turn")
		end_turn()
	else:
		TurnState = States.turn.GUESS
		show_message("$" + str(value))
		guess_score = value
		turn_state_machine()

func _on_guess_complete(c,g):
	if c == 0 and guess_score != -2:  # second condition prevents turn from ending if free play was landed on
		end_turn()
	else:
		TurnState = States.turn.CORRECT
		var is_vowel = false
		
		if g in ["A","E","I","O","U"]:
			c = 1
			is_vowel = true
		
		update_score(c, is_vowel)
		
		guess_score = 0
		turn_state_machine()

func _on_only_vowels():
	can_spin = false

func _on_solve_attempt():
	TurnState_prev = TurnState  # this is needed for if solve attempt is cancelled
	TurnState = States.turn.SOLVE
	
	turn_state_machine()
	
func _on_solve_cancelled():
	TurnState = TurnState_prev  # reinstate the previous turn state
	
	turn_state_machine()

func _on_round_over():
	TurnState = States.turn.END
	
	end_round()

## auxiliary functions
func show_message(msg):
	var label = get_node("Tmp/Round")
	
	label.text = msg
	label.show()
	await get_tree().create_timer(1.0).timeout
	label.hide()
