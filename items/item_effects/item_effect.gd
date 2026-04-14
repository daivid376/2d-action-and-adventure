@tool
class_name ItemEffect extends Resource
@export_file('*.wav','*.mp3','*.ogg') var audio_path :String = ''
var _cache_audio : AudioStream
func _get_default_audio_path()-> String:
	return ''
func _apply_editor_default_audio_path()-> void:
	if not audio_path.is_empty():
		return
	var default_audio_path = _get_default_audio_path()
	if default_audio_path.is_empty():
		return
	audio_path = default_audio_path
	notify_property_list_changed()
	
func _init() -> void:
	if Engine.is_editor_hint():
		_apply_editor_default_audio_path()
	pass
func _get_audio()-> AudioStream:
	if !_cache_audio:
		if audio_path.is_empty():
			return null
		_cache_audio = ResourceLoader.load(audio_path) as AudioStream
	return _cache_audio

func use()->void:
	pass
