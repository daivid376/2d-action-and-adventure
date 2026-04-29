class_name BarredDoor extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
var is_active : bool = false 

func _ready() -> void:
	_refresh_active_display()
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

func _set_active(value)->void:
	is_active = value
	if not is_node_ready():
		return
	_refresh_active_display()
func _refresh_active_display()->void:
	if is_active:
		animation_player.play("door_open")
		var anim_len := animation_player.current_animation_length
		#animation_player.seek(0.49,true)
		animation_player.call_deferred('seek',anim_len,true)
	else:
		animation_player.play('RESET')
