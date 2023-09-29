extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	## connect guess tracker and puzzle
	# guess a letter
	var puzzle = get_node("Puzzle")
	var tracker = get_node("GameControl/GuessTracker")
	
	tracker.make_a_guess.connect(puzzle._on_guess_made)

	# try to solve puzzle

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
