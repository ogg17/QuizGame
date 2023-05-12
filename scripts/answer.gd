extends Button

var button_id = 0

signal pressed_with_id(id)

func _on_pressed():
	pressed_with_id.emit(button_id)
