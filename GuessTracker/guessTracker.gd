extends HBoxContainer

signal make_a_guess(g)

var vowels = []
var consonants = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for c in get_children():
		var start_ascii = c.name.unicode_at(0)  # per comment at https://ask.godotengine.org/106152/convert-an-character-to-ascii-value
		
		# TODO - add applicaiton of styleboxes
		if start_ascii < "U".unicode_at(0):
			for i in range(10):
				var button_i = create_button(char(start_ascii + i))
				c.add_child(button_i)
		else:  # some special things for the last column to keep it symmetric
			for i in range(-2,8):
				var button_i
				if i < 0 or i > 5:
					button_i = create_button("")
					button_i.hide_button()
				else:
					button_i = create_button(char(start_ascii + i))
				
				c.add_child(button_i)

func create_button(text):
	var button=preload("res://GuessTracker/guessButton.tscn")
	var b = button.instantiate()

	b.guess_a_letter.connect(_on_guess_made)  # handle the signal when a guess is made
	b.text = text
	b.name = text
	
	# create lists of references to buttons for vowels and consonants
	# used for game cues (no consonants/vowels left to guess)
	if text in ["A","E","I","O","U"]:
		vowels.append(b)
	elif text == "":
		pass
	else:
		consonants.append(b)
		
	return b


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func reset_tracker():
	for c in consonants:
		c.disabled = false
	
	for c in vowels:
		c.disabled = false

func _on_guess_made(g):
	make_a_guess.emit(g)  # propagate the guess so it can be used by the puzzle board
	# emitted in two stages as it is easier to connect to the buttons here rather than at main
	# scene level - here only one connection is needed, instead of 26

# disables buttons for consonants if there are only vowels left in the puzzle
func only_vowels():
	for c in consonants:
		c.disabled = true

# disables buttons for vowels if there are only consonants left in the puzzle
func only_consonants():
	for c in vowels:
		c.disabled = true

func hide_consonants():
	for c in consonants:
		c.hide_button()
		
func show_consonants():
	for c in consonants:
		c.show_button()

func hide_vowels():
	for c in vowels:
		c.hide_button()

func show_vowels():
	for c in vowels:
		c.show_button()
