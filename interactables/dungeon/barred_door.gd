class_name BarredDoor extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	#animation_player.animation_finished.connect(_on_animation_finished)
	pass

func activate() -> void:
	audio_stream_player_2d.play()
	if animation_player.is_playing():
		var t := animation_player.current_animation_position
		animation_player.play("door_open")
		animation_player.seek(t,true)
	else:
		animation_player.play("door_open")


func deactivate() -> void:
	audio_stream_player_2d.play()
	if animation_player.is_playing():
		var t := animation_player.current_animation_position
		animation_player.play_backwards("door_open")
		animation_player.seek(t,true)
	else:
		animation_player.play_backwards("door_open")
