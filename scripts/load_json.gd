extends Node

const json_path = "res://questions.json"

var json_data

func read_json():
	if not FileAccess.file_exists(json_path):
		return "We don't have a json file."

	var json_string = FileAccess.get_file_as_string(json_path)
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		var msg = "JSON Parse Error: " + json.get_error_message() + " in " + json_path + " at line " + str(json.get_error_line())
		print(msg)		
		return msg

	json_data = json.get_data()
	return data_cheking(json_data)
	

func data_cheking(json):		
	if not json.size() > 0:
		return "JSON Parse Error: Empty json"	
	
	for data in json:
		if not data.has("question"):
			return "JSON Parse Error: Json not contain question"
		if not data["question"] is String:
			return "JSON Parse Error: Json question text is not a string"
		if not data.has("answers"):
			return "JSON Parse Error: Json not contain answers"
		if not data["answers"].size() > 0:
			return "JSON Parse Error: Json not contain answers"
		if not data.has("background"):
			return "JSON Parse Error: Json not contain background"
		if not data["background"] is String:
			return "JSON Parse Error: Json background is not a path string"
		
		for answer in data["answers"]:
			if not answer.has("text"):
				return "JSON Parse Error: Json not contain answer text"
			if not answer["text"] is String:
				return "JSON Parse Error: Json answer text is not a string"
			if not answer.has("correct"):
				return "JSON Parse Error: Json not contain answer correctness"
			if not answer["correct"] is bool:
				return "JSON Parse Error: Json answer correctness is not a boolean"

	return "OK"
