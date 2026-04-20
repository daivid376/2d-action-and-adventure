@tool
class_name Interactable extends Node
var can_interact :bool = true

var persistent_id : String = ''
var states := {} #{'chest_state' : ChestState.CLOSED}
static var id_poor : Array[String] = []
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	SaveManager.game_loaded.connect(_on_game_loaded)
	_make_persistent_id()
	print('levelPath ',_make_persistent_id())
	restore_persistent_states()
	pass

func _make_persistent_id()->String:
	#'res://levels/area01/01.tscn/TheasureChest2'
	var level_path = get_tree().current_scene.scene_file_path
	persistent_id = level_path.path_join(name)
	return persistent_id

func _exit_tree() -> void:
	pass

func interact()->void:
	pass
	
func capture_persistent_states()-> void:
	WorldState.set_object_states(persistent_id,states)
func restore_persistent_states()-> void:
	states = WorldState.get_object_states(persistent_id)
	for state_name in states:
		self.set(state_name,states[state_name])
	

func _on_game_loaded()->void:
	print('on game loaded : ',self ,' stored persistent=', WorldState.object_states)
	restore_persistent_states()
	pass
