extends CanvasLayer

var paused :bool = false
@onready var save_button: Button = $Control/VBoxContainer/Save_Button
@onready var load_button: Button = $Control/VBoxContainer/Load_Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_pause_menu(false)
	save_button.pressed.connect(_on_save_button_pressed)
	load_button.pressed.connect(_on_load_button_pressed)
	
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if !paused:
			set_pause_menu(true)
		else:
			set_pause_menu(false)
		get_viewport().set_input_as_handled()

func set_pause_menu(_bool : bool)-> void:
	self.visible = _bool
	paused = _bool
	get_tree().paused = _bool
	if _bool:
		save_button.grab_focus()
	
func _on_save_button_pressed()-> void:
	if !paused:
		return
	SaveManager.save_game()
	set_pause_menu(false)
	pass
func _on_load_button_pressed()-> void:
	if !paused:
		return
	SaveManager.load_game()
	set_pause_menu(false)
	pass
