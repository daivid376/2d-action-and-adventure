extends Node
var object_states : Dictionary
#key 'chest_001'
#value {'chest_state' : ChestState.OPENED}
const SAVE_FIELDS := ['object_states']
func _ready() -> void:
	SaveManager.register_savable(self,'object_states')
	SaveManager.game_loading.connect(_on_game_loading)
func set_object_state(persistent_id:String, state : Dictionary)->void:
	object_states[persistent_id] = state

func get_object_state(persistent_id:String)-> Dictionary:
	#if object_states.has(persistent_id):
	if !object_states:
		return {}
	return object_states.get(persistent_id,{})

func clear()->void:
	object_states = {}
	
func _on_game_loading():
	clear()
	pass
