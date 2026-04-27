class_name LockedDoor extends OpenableInteractable
@onready var area_2d: Area2D = $Area2D
@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var static_collision: CollisionShape2D = $StaticBody2D/StaticCollision
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../AudioStreamPlayer2D"
@export var key_item : Item
const DUNGEON_KEY = preload("uid://b7lo2f4hpkkwg") as Item
const locked_door_audio: AudioStream = preload("res://interactables/dungeon/locked_door.wav") 
const unlock_door_audio: AudioStream = preload("res://interactables/dungeon/unlock_door.wav")

func _ready() -> void:
	_refresh_open_state()
	#print('ready door_state ', door_state)
	pass
func on_interacted() -> void:
	#print('interact door state, ',door_state)
	if PlayerManager.INVENTORY.consume_item(key_item):
		is_opened = true
		audio_stream_player_2d.stream = unlock_door_audio
		audio_stream_player_2d.play()
		_refresh_open_state()
	else:
		audio_stream_player_2d.stream = locked_door_audio
		audio_stream_player_2d.play()
		
	
func _refresh_open_state()->void:
	static_collision.disabled = is_opened
	sprite_2d.visible = !is_opened
	
