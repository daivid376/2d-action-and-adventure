class_name ItemEffectHeal extends ItemEffect

@export var heal_amount : int = 1
@export var audio : AudioStream

func use()->void:
	LevelManager.player.update_hp(heal_amount)
	if audio:
		PauseMenuGui.audio_stream_player_2d.stream = audio
		PauseMenuGui.audio_stream_player_2d.play()
	pass
