extends Control

@export var a_button : Button
@export var a_button_space : int
@export var a_button_group_height : float

var data
var current_question = 1
var correct_answers_count = 0
var a_buttons : Array
var start_button_position

signal pressed_with_bool(value)
signal end_questions(correct_answers_count)

func _ready():	
	remove_child(a_button)

func load_data(json_data):
	data = json_data

func restart_game():
	correct_answers_count = 0
	current_question = 1

func next_answer():
	if current_question > data.size():
		end_questions.emit(correct_answers_count)
		return		

	var answer_count = data[current_question - 1]["answers"].size()
	start_button_position = get_viewport_rect().size.y * a_button_group_height - answer_count * a_button_space / 2
	set_buttons(answer_count)

	$QuestionTitle.text = "Question %d" % current_question
	$QuestionLabel.text = "%s" % data[current_question - 1]["question"]
	$Background.texture = load("res://" + data[current_question - 1]["background"])	

func set_buttons(answer_count):
	for i in range(0, answer_count):
		if i >= a_buttons.size(): 
			var target_button = a_button.duplicate()
			set_new_button(target_button, i)	
			a_buttons.append(target_button)
		else:
			set_button(a_buttons[i], i)
	
	if answer_count < a_buttons.size():
		for i in range(data[current_question - 1]["answers"].size(), a_buttons.size()):
			a_buttons[i].hide()	

func set_new_button(button, i):
	set_button(button, i)
	button.button_id = i
	button.pressed_with_id.connect(_on_answer_pressed)		
	add_child(button)

func set_button(button, i):
	button.position.y = start_button_position + i * a_button_space	
	button.text = data[current_question - 1]["answers"][i]["text"]
	button.show()

func _on_answer_pressed(id):
	var correct = data[current_question - 1]["answers"][id]["correct"]
	if correct:
		correct_answers_count += 1
	pressed_with_bool.emit(correct)
	current_question += 1
