class_name Pushable_Statue extends RigidBody2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
var push_direction : Vector2 = Vector2.ZERO : set = _set_push
var speed :float = 30.
var play_audio = false
const PERSISTENT_PROPERTIES := ['global_position']

	
	
func _physics_process(_delta: float) -> void:
	linear_velocity = push_direction * speed
	
func _set_push(value)->void:
	push_direction = value
	if push_direction != Vector2.ZERO:
		if not audio_stream_player_2d.playing:
			audio_stream_player_2d.play()
	else:
		if audio_stream_player_2d.playing:
			audio_stream_player_2d.stop()
