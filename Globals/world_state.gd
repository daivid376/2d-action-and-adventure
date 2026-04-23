extends Node
var object_states : Dictionary
#key 'chest_001'
#value {'chest_state' : ChestState.OPENED}
var object_properties : Dictionary
#key 'level/pushalbe_statue'
#value {'pushalbe_statue.global_position' : Vector2}

const PERSISTENT_SECTIONS := ['object_states','object_properties']

func _ready() -> void:
	SaveManager.game_start_loading.connect(_on_game_loading)
func set_object_states(persistent_id:String, states : Dictionary)->void:
	object_states[persistent_id] = states

func set_object_persistent_properties(persistent_id:String, properties :Dictionary) -> void:
	object_properties[persistent_id] = properties

func get_object_states(persistent_id:String)-> Dictionary:
	#if object_states.has(persistent_id):
	if !object_states:
		return {}
	return object_states.get(persistent_id,{})

func get_object_persistent_properties(persistent_id:String) -> Dictionary:
	if !object_properties:
		return {}
	return object_properties.get(persistent_id,{})

func clear()->void:
	object_states = {}
	object_properties = {}
	
func _on_game_loading():
	clear()
	pass
