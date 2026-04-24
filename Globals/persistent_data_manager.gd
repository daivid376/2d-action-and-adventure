extends Node

var persistent_registry := {} #{p_id : instance}
var persistent_snapshots := {} 
#{p_id:{field: value}}
#{p_id: [slots]}

func _ready() -> void:
	SaveManager.game_start_saving.connect(_capture_all)
	SaveManager.game_start_loading.connect(clear)
	SaveManager.game_loaded.connect(_apply_all)
	pass

func _capture_all()-> void:
	for persistent_id in persistent_registry.keys():
		capture_persistent_data(persistent_id)

func _apply_all()-> void:
	#print('apply all ,data= ',persistent_snapshots)
	#print('persistent_registry ',persistent_registry)
	if persistent_registry.is_empty() or persistent_snapshots.is_empty():
		return
	for persistent_id in persistent_registry.keys():
		apply_persistent_data(persistent_id)


func capture_persistent_data(persistent_id:String) -> void:
	if persistent_registry.has(persistent_id):
		var object : Object= persistent_registry[persistent_id]
		var field_values := {}
		if 'PERSISTENT_FIELDS' in object:
			for field in object.get('PERSISTENT_FIELDS'):
				var value = object.get(field)
				field_values[field] = value
			persistent_snapshots[persistent_id] = field_values
		elif object.has_method('to_persistent_data'):
			persistent_snapshots[persistent_id] = object.to_persistent_data()
	#print('[PDM capture_persistent_data ',persistent_snapshots)		
func apply_persistent_data(persistent_id:String) -> void:
	#for persistent_id in persistent_registry:
	var object : Object = persistent_registry[persistent_id]
	#print('[PDM apply persistent data] object= ',object)
	#print('[PDM apply persistent data] persistent_snapshots= ',persistent_snapshots)
	
	if not persistent_snapshots.has(persistent_id):
		return
	if 'PERSISTENT_FIELDS' in object:
		var field_values : Dictionary = persistent_snapshots[persistent_id]
		for field in object.get('PERSISTENT_FIELDS'):
			if field_values.has(field):
				var value = field_values[field]
				#print('[PDM apply persistent data] field= ', field,' value= ' ,value)
				object.set(field,value)
	elif object.has_method('from_persistent_data'):
		var stored_data = persistent_snapshots[persistent_id]
		object.from_persistent_data(stored_data)
		


func register_persistent_object(node:Object,persistent_id:String)->void:
	if !persistent_id:
		push_error('register_persistent_object failed: persistent_id is empty')
		return
	if persistent_registry.has(persistent_id):
		push_error('duplicate save_id: %s' %persistent_id)
		return
	persistent_registry[persistent_id] = node
	#print('register ',persistent_registry)
	pass
	
func unregister_persistent_object(persistent_id: String)-> void:
	if persistent_registry.has(persistent_id):
		persistent_registry.erase(persistent_id)
	#print('unregister ', persistent_registry)

func clear()->void:
	persistent_snapshots = {}
