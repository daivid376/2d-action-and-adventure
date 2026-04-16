@tool
class_name ItemEffectHeal extends ItemEffect

@export var heal_amount : int = 1
const DEFAULT_AUDIO_PATH = "res://items/item_effects/hp-up.wav"
func _get_default_audio_path()-> String:
	return DEFAULT_AUDIO_PATH

func use()->void:
	PlayerManager.player.update_hp(heal_amount)
	
	var stream = _get_audio()
	if stream:
		PauseMenuGui.audio_stream_player_2d.stream = stream
		PauseMenuGui.audio_stream_player_2d.play()
	pass
