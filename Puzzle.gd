extends Node2D

# globals - but does these make sense to be global?
var new_puzzle

# JSON parsing based off example in Godot documentation:
# https://docs.godotengine.org/en/stable/classes/class_json.html
var json = JSON.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	new_puzzle = get_puzzle("res://answers.json")
	var category = get_node("Category")
	
	# initialize the puzzle
	category.text = new_puzzle.Category


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
	
	# not sure how else to do this, may need to revisit for better formatting
	if puzzle_dict.NumLines >= 1: puzzle_dict.Line1 = selected_answer[2]
	if puzzle_dict.NumLines >= 2: puzzle_dict.Line2 = selected_answer[3]
	if puzzle_dict.NumLines >= 3: puzzle_dict.Line3 = selected_answer[4]
	if puzzle_dict.NumLines >= 4: puzzle_dict.Line4 = selected_answer[5]
	
	return puzzle_dict;
