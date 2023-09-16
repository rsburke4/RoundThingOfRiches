extends Node2D

#Makes the properties menu look pretty.
#References here: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
@export_category("Scraping Options")
@export_file var data_file
@export var verify: bool = false
@export var output: String = "answers.json"
var file
var row_data
var data_dict


func verify_data(data):
	for row in data:
		for col in data:
			print(str(col))
	print("\n")

# Called when the node enters the scene tree for the first time.
func parse_data():
	#Abort if answers.json already exists
	if(FileAccess.file_exists(output)):
		print("Answer JSON exitsts. Aborting")
		return
	#Otherwise proceed opening file as string
	file = FileAccess.get_file_as_string(data_file)
	#Get table data only from webpage
	row_data = file.split("row")
	data_dict = Array()
	
	
	#Some Local Variables for parsing
	var columns
	var original_column
	var start_char
	var end_char
	
	#Split strings, and parse data into manageable chunks
	for row in row_data:
		if row.contains("column"):
			columns = row.split("column")
			var column_array = Array()
			for column in columns:
				original_column = column
				start_char = column.find(">")
				end_char = column.find("</")
				column = column.substr(start_char + 1, end_char - start_char-1)
				##Any Additional String Cleaning
				#I'm aware there's better ways.
				if(column.contains("&amp")):
					column = column.replace("&amp;", "&")
				if(column.contains("<br/>")):
					column = column.replace("<br/>", "")
				#If this original column is the subject (index 1)
				#replace this code with '. Otherwise, just chunk it.
				if(column.contains("&#39;")):
					if(columns.find(original_column) == 1):
						column = column.replace("&#39;", "'")
					else:
						column = column.replace("&#39;", "")
				#Add the columns to an array
				if(len(column) > 0):
					column_array.append(column)
			if(column_array.size() > 0):
				data_dict.append(column_array)
					
	#Prints everything in table. Will take a LONG time
	if(verify == true):
		verify_data(data_dict)
	
	#Save json string to file
	var json_string = JSON.stringify(data_dict)
	var output_file = FileAccess.open("answers.json", FileAccess.WRITE)
	output_file.store_string(json_string)
	output_file.close()
	
	print("Answers parsed to JSON")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
