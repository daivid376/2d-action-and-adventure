@tool
class_name Interactable extends Node
var can_interact :bool = true

var persistent_id : String = ''
var states := {} :set = _set_states  #{'chest_state' : ChestState.CLOSED}

const PERSISTENT_PROPERTIES := ['states']
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	#SaveManager.game_loaded.connect(_on_game_loaded)
	#_make_persistent_id()
	#print('levelPath ',_make_persistent_id())
	#restore_persistent_states()
	pass

func _make_persistent_id()->String:
	#'res://levels/area01/01.tscn/TheasureChest2'
	var level_path = get_tree().current_scene.scene_file_path
	persistent_id = level_path.path_join(name)
	return persistent_id


func interact()->void:
	pass
	
func _set_states(value)->void:
	states = value
	print('interactable _set ', states)
	for state in states:
		self.set(state,states[state])
