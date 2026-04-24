extends Node

const SAVE_DIR = 'user://save/'

signal game_start_loading
signal game_loaded
signal game_saved
signal game_start_saving

var loaded_save_data:= {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func save_game()-> void:
	print('save game')
	game_start_saving.emit()
	var save_file_data: Dictionary = {
		'meta':{
			'save_version' : 1,
			'save_time' : Time.get_time_string_from_system(),
			'save_level' : get_tree().current_scene.scene_file_path
		},
		'objects_data':{},
	}
	save_file_data['objects_data'] = serialize_persistent_snapshots()
	print('save data: ', save_file_data)
	
	#for test
	#loaded_save_data = result
	save_file(save_file_data)
	game_saved.emit()
	
func serialize_persistent_snapshots()-> Dictionary:
	var persistent_snapshots : Dictionary = PersistentDataManager.persistent_snapshots
	var objects_save_data := {}
	for persistent_id:String in persistent_snapshots:
		var persistent_data = persistent_snapshots[persistent_id]
		
		if persistent_data is Dictionary:
			var serialized_data := {}
			for field in persistent_data:
				var value = persistent_data[field]
				serialized_data[field] = serialize_value(value)
			objects_save_data[persistent_id] =  serialized_data
		else:
			objects_save_data[persistent_id] =  persistent_data
	return objects_save_data
	
func load_game()-> void:
	print('load game')
	loaded_save_data = load_file()
	game_start_loading.emit()
	print('ready to apply saved data')
	await self._load_saved_level(loaded_save_data)
	deserialize_saved_data(loaded_save_data)
	game_loaded.emit()

func deserialize_saved_data(saved_data : Dictionary):
	var objects_data :Dictionary = saved_data['objects_data']
	for persistent_id in objects_data:
		var object_data = objects_data[persistent_id]
		if object_data is Dictionary:
			var deserialized_object_data := {}
			for field in object_data:
				var value = object_data[field]
				deserialized_object_data[field] = deserialize_value(value)
			PersistentDataManager.persistent_snapshots[persistent_id] = deserialized_object_data
		else:
			PersistentDataManager.persistent_snapshots[persistent_id] = object_data

func _load_saved_level(save_data : Dictionary)->void:
	var saved_scene_path: String = save_data.get("meta", {}).get("save_level", "")
	if not saved_scene_path.is_empty():
		print('save manager/load saved level/saved_scene_path ',saved_scene_path)
		await LevelManager.load_level(saved_scene_path)

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
