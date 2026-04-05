extends Node

const SAVE_DIR = 'user://save/'

signal game_loaded
signal game_saved

var save_registry:= {}
var save_data:= {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func save_game()-> void:
	print('save game')
	var result: Dictionary = {
		'meta':{
			'save_version' : 1,
			'save_time' : Time.get_time_string_from_system(),
			'save_level' : get_tree().current_scene.scene_file_path
		},
		'objects':{},
	}
	for save_id:String in save_registry.keys():
		var _obj: Object = save_registry[save_id]
		var data : Dictionary= build_object_save_data(_obj)
		if data.is_empty():
			continue
		result['objects'][save_id] = data
	print('save data: ', result)
	#for test
	#save_data = result
	save_file(result)
	game_saved.emit()
	
func load_game()-> void:
	print('load game')
	save_data = load_file()
	if !save_registry.is_empty():
		var saved_scene_path = save_data['meta']['save_level']
		if saved_scene_path:
			await LevelManager.load_level(saved_scene_path)
		for save_id in save_registry:
			print('save_registry ',save_registry)
			print('save_id ',save_id)
			var _obj = save_registry[save_id]
			if save_data['objects'].has(save_id):
				var data = save_data['objects'][save_id]
				if _obj and data:
					print('apply data', data)
					print('_obj:',_obj)
					apply_object_save_data(_obj,data)
	game_loaded.emit()
	
func build_object_save_data(_obj:Object)-> Dictionary:
	var data := {}
	if 'SAVE_FIELDS' not in _obj:
		return data
	var fields: Array = _obj.SAVE_FIELDS
	for key in fields:
		var _v = _obj.get(key)
		data[key] = serialize_value(_v)
	return data

func apply_object_save_data(_obj:Object,data:Dictionary)-> void:
	if 'SAVE_FIELDS' not in _obj:
		return
	for field in _obj.SAVE_FIELDS:
		if data.has(field):
			var _v = data[field]
			print('field: ',field)
			print('value: ', _v)
			var deserialized_value = deserialize_value(_v)
			_obj.set(field,deserialized_value)
			#if field == 'hp':
				##_obj.set('hp',3.3)
				#print('deserialized_value: ', deserialized_value)
				#print('hp value type: ',type_string(typeof(deserialize_value(_v))))
func serialize_value(value):
	if value is Vector2:
		return {'__type': 'Vector2',
		'x' : value.x,
		'y' : value.y
		}
	return value
func deserialize_value(value):
	if value is Dictionary and value.has('__type'):
		match value['__type']:
			'Vector2':
				return Vector2(value.get('x',0.),value.get('y',0.))
			_:
				return value
	return value	

func register_savable(node:Object,save_id:String)->void:
	if !save_id:
		push_error('register_savable failed: save_id is empty')
		return
	if save_registry.has(save_id):
		push_error('duplicate save_id: %s' %save_id)
		return
	save_registry[save_id] = node
	pass
	
func unregister_savable(save_id: String)-> void:
	if save_registry.has(save_id):
		save_registry.erase(save_id)

func save_file(data:Dictionary)->void:
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	var file := FileAccess.open(SAVE_DIR + 'save.sav',FileAccess.WRITE)
	var save_json = JSON.stringify(data,'\t')
	file.store_string(save_json)

func load_file()->Dictionary:
	var file := FileAccess.open(SAVE_DIR + 'save.sav',FileAccess.READ)
	if !file:
		push_error('read file fail: %s' %FileAccess.get_open_error())
		return {}
	var file_string := file.get_as_text()
	return JSON.parse_string(file_string)
