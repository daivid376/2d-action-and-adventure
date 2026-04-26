extends Node

const SAVE_DIR = 'user://save/'

signal game_load_started
signal game_loaded
signal game_saved
signal game_save_started
var is_loading_game := false
var loaded_save_data:= {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func save_game()-> void:
	print('save game')
	game_save_started.emit()
	var save_file_data: Dictionary = {
		'meta':{
			'save_version' : 1,
			'save_time' : Time.get_time_string_from_system(),
			'save_level' : get_tree().current_scene.scene_file_path
		},
		'persistent_snapshots':{},
	}
	save_file_data['persistent_snapshots'] = serialize_persistent_snapshots()
	print('save data: ', save_file_data)
	
	#for test
	#loaded_save_data = result
	if write_save_file(save_file_data):
		game_saved.emit()

func load_game()-> void:
	print('load game')
	loaded_save_data = load_save_file()
	if loaded_save_data.is_empty():
		return
		
	is_loading_game = true
	game_load_started.emit()
	print('ready to apply saved data')
	deserialize_snapshots_from_save_data(loaded_save_data)
	await self._load_level_from_save_data(loaded_save_data)
	is_loading_game = false
	game_loaded.emit()

func serialize_persistent_snapshots()-> Dictionary:
	var persistent_snapshots : Dictionary = PersistentDataManager.get_all_snapshots()
	var serialized_snapshots := {}
	for persistent_id:String in persistent_snapshots:
		var snapshot = persistent_snapshots[persistent_id]
		if snapshot is Dictionary:
			var serialized_snapshot := {}
			for property_name in snapshot:
				var value = snapshot[property_name]
				serialized_snapshot[property_name] = serialize_value(value)
			serialized_snapshots[persistent_id] =  serialized_snapshot
		else:
			serialized_snapshots[persistent_id] =  snapshot
	return serialized_snapshots

func deserialize_snapshots_from_save_data(saved_data : Dictionary):
	var serialized_snapshots: Dictionary = saved_data.get("persistent_snapshots", {})
	for persistent_id in serialized_snapshots:
		var serialized_snapshot = serialized_snapshots[persistent_id]
		if serialized_snapshot is Dictionary:
			var snapshot := {}
			for property_name in serialized_snapshot:
				var value = serialized_snapshot[property_name]
				snapshot[property_name] = deserialize_value(value)
			PersistentDataManager.set_snapshot(persistent_id,snapshot)
		else:
			PersistentDataManager.set_snapshot(persistent_id, serialized_snapshot)

func _load_level_from_save_data(save_data : Dictionary)->void:
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

func write_save_file(data:Dictionary)->bool:
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	var file := FileAccess.open(SAVE_DIR + 'save.sav',FileAccess.WRITE)
	if file == null:
		push_error("Open save file failed: %s" % FileAccess.get_open_error())
		return false
	var save_json = JSON.stringify(data,'\t')
	file.store_string(save_json)
	return true

func load_save_file()->Dictionary:
	var file := FileAccess.open(SAVE_DIR + 'save.sav',FileAccess.READ)
	if !file:
		push_error('read file fail: %s' %FileAccess.get_open_error())
		return {}
	var file_string := file.get_as_text()
	var parsed = JSON.parse_string(file_string)

	if not parsed is Dictionary:
		push_error("Save file is not a valid Dictionary.")
		return {}

	return parsed
