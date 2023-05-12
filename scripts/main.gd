extends Node

@export var main_menu_name = "main_menu"
@export var json_name = "json"
@export var game_name = "game"
@export var result_name = "result"
@export var restart_name = "restart"

const scenes_folder = "res://scenes/"
const scene_extension = ".tscn"

var main_menu
var json
var game
var result
var restart

var windows = Array()

func _ready():
	$ErrorDialog.confirmed.connect(_on_error_confirmed)
	$ErrorDialog.canceled.connect(_on_error_confirmed)

	var error = load_questions()
	if not error == "OK":		
		load_error(error)
	else:
		load_main_menu()	
		load_game()
		load_result()
		load_restart()
		change_window(main_menu)

func load_questions():	
	json = load_scene(json_name)
	add_child(json)			
	return json.read_json()

func load_main_menu():	
	main_menu = load_window_scene(main_menu_name)	
	main_menu.button.pressed.connect(_on_new_game_pressed)	

func load_game():
	game = load_window_scene(game_name)	
	game.load_data(json.json_data)
	game.next_answer()
	game.pressed_with_bool.connect(_on_answer_pressed)
	game.end_questions.connect(_on_end_questions)	

func load_result():
	result = load_window_scene(result_name)
	result.next_button.pressed.connect(_on_next_pressed)	

func load_restart():
	restart = load_window_scene(restart_name)	
	restart.restart_button.pressed.connect(_on_restart_pressed)

func load_scene(scene_name):
	return load(scenes_folder + scene_name + scene_extension).instantiate()

func load_window_scene(scene_name):
	var scene = load_scene(scene_name)
	add_child(scene)
	windows.append(scene)
	return scene

func load_error(message):
	$ErrorDialog.title = "Error!"	
	$ErrorDialog.dialog_text = message
	$ErrorDialog.cancel_button_text = "Close"
	$ErrorDialog.popup_centered()

func change_window(window):
	for w in windows:
		if(w != window):
			w.hide()
		else:
			w.show()	

func _on_new_game_pressed():	
	change_window(game)	

func _on_end_questions(correct_answers_count):	
	restart.show_restart(correct_answers_count, game.data.size())
	change_window(restart)

func _on_answer_pressed(value):
	result.show_result(value)
	change_window(result)

func _on_next_pressed():
	change_window(game)
	game.next_answer()

func _on_restart_pressed():
	game.restart_game()
	game.next_answer()
	change_window(main_menu)

func _on_error_confirmed():
	get_tree().quit()
