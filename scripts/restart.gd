extends Control

var restart_button

func _ready():
	restart_button = get_node("RestartButton")

func show_restart(correct_answers_count, answers_count):
	var text = "%d correct answers out of %d" % [correct_answers_count, answers_count]
	get_node("ResultLabel").text = text

