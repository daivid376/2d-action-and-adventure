extends Node

var persistent_registry := {} #{p_id : instance}
var persistent_snapshots := {} 
# { persistent_id: snapshot }
# snapshot can be:
# - Dictionary: { property_name: property_value }
# - Variant: custom data returned by to_persistent_data()

func _ready() -> void:
	SaveManager.game_save_started.connect(_capture_all)
	SaveManager.game_load_started.connect(clear_snapshots)
	pass

func _capture_all()-> void:
	for persistent_id in persistent_registry.keys():
		capture_persistent_data(persistent_id)
	print(persistent_snapshots)

func capture_persistent_data(persistent_id:String) -> void:
	if persistent_registry.has(persistent_id):
		var object : Object= persistent_registry[persistent_id]
		var snapshot := {}
		if 'PERSISTENT_PROPERTIES' in object:
			for property_name in object.get('PERSISTENT_PROPERTIES'):
				var value = object.get(property_name)
				snapshot[property_name] = value
			persistent_snapshots[persistent_id] = snapshot
		elif object.has_method('to_persistent_data'):
			persistent_snapshots[persistent_id] = object.to_persistent_data()

func apply_persistent_data(persistent_id:String) -> void:
	if not persistent_snapshots.has(persistent_id):
		return
	var object : Object = persistent_registry[persistent_id]
	if 'PERSISTENT_PROPERTIES' in object:
		var snapshot : Dictionary = persistent_snapshots[persistent_id]
		for property_name in object.get('PERSISTENT_PROPERTIES'):
			if snapshot.has(property_name):
				var value = snapshot[property_name]
				object.set(property_name,value)
	elif object.has_method('from_persistent_data'):
		var stored_data = persistent_snapshots[persistent_id]
		object.from_persistent_data(stored_data)
		
func set_snapshot(persistent_id: String, snapshot)->void:
	persistent_snapshots[persistent_id] = snapshot

func get_snapshot(persistent_id: String) -> Variant:
	return persistent_snapshots.get(persistent_id,null)

func get_all_snapshots()-> Dictionary:
	return persistent_snapshots

func register_persistent_object(object:Object,persistent_id:String)->bool:
	if !persistent_id:
		push_error('register_persistent_object failed: persistent_id is empty')
		return false
	if persistent_registry.has(persistent_id):
		push_error('duplicate save_id: %s' %persistent_id)
		return false
	persistent_registry[persistent_id] = object
	#print('register ',persistent_registry)
	return true
	
func unregister_persistent_object(persistent_id: String)-> void:
	if persistent_registry.has(persistent_id):
		persistent_registry.erase(persistent_id)
	#print('unregister ', persistent_registry)

func clear_snapshots()->void:
	persistent_snapshots = {}
