extends HBoxContainer

signal make_a_guess(g)

# Called when the node enters the scene tree for the first time.
func _ready():
	var button=preload("res://GuessTracker/guessButton.tscn")
	
	for c in get_children():
		var start_ascii = c.name.unicode_at(0)  # per comment at https://ask.godotengine.org/106152/convert-an-character-to-ascii-value
		
		# TODO - add applicaiton of styleboxes
		if start_ascii < "U".unicode_at(0):
			for i in range(10):
				var button_i = button.instantiate()
			
				button_i.text = char(start_ascii + i)
				c.add_child(button_i)
				button_i.guess_a_letter.connect(_on_guess_made)  # handle the signal when a guess is made
		else:  # some special things for the last column to keep it symmetric
			for i in range(-2,8):
				var button_i = button.instantiate()
				
				if i < 0 or i > 5:
					button_i.hide_button()
				else:
					button_i.text = char(start_ascii + i)
					button_i.guess_a_letter.connect(_on_guess_made)  # handle the signal when a guess is made
				
				c.add_child(button_i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_guess_made(g):
	make_a_guess.emit(g)  # propagate the guess so it can be used by the puzzle board
	# emitted in two stages as it is easier to connect to the buttons here rather than at main
	# scene level - here only one connection is needed, instead of 26
