@tool
class_name Interactable extends Node
var can_interact :bool = true

@export var persistent_id : String = ''
static var id_poor : Array[String] = []
func _ready() -> void:
	SaveManager.game_loaded.connect(_on_game_loaded)
	pass

func _exit_tree() -> void:
	pass

func interact()->void:
	pass
func apply_persistent_state() -> void:
	pass
func _on_game_loaded()->void:
	print('on game loaded : ',self ,' stored persistent=', WorldState.object_states)
	apply_persistent_state()
	pass
