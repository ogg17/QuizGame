extends Control

var next_button

func _ready():
	next_button = get_node("NextButton")

func show_result(result):
	if result:
		$LabelResult.text = "Right!"
	else:
		$LabelResult.text = "Wrong!"
