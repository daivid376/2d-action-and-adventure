class_name PressurePlate extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
const AUDIO_ACTIVE : AudioStream= preload("uid://ciuy68bgu2ayq")
const AUDIO_DEACTIVE : AudioStream = preload("uid://mlbkija7helf")

var interacting_body_count : int = 0
signal activated
signal deactivated
var is_active :bool = false

const PERSISTENT_PROPERTIES = ['is_active']
@export var target : Node
func _ready() -> void:

	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)
	print('pressure plate ready active ',is_active)
	_refresh_active_display()
	LevelManager.level_load_started.connect(func(): area_2d.set_block_signals(true))
	pass

func _on_body_entered(_body)->void:
	interacting_body_count += 1
	var bodies := area_2d.get_overlapping_bodies()
	print('entered bodies overlap ',bodies)
	update_active_state()
	
func _on_body_exited(_body)->void:
	print('_on body exited: ',_body)
	interacting_body_count -= 1
	update_active_state()
	
func update_active_state()->void:
	print('pressure plate,update_active_state,active  ',is_active)
	if interacting_body_count > 0 and not is_active:
		is_active = true
		sprite_2d.frame = 40
		
		activated.emit()
		if target and target.has_method('activate'):
			target.call_deferred('activate')
		if !audio_stream_player_2d:
			return
		audio_stream_player_2d.stream = AUDIO_ACTIVE
		audio_stream_player_2d.play()
	if interacting_body_count == 0 and is_active:
		is_active = false
		sprite_2d.frame = 41
		
		
		deactivated.emit()
		if target and target.has_method('deactivate'):
			target.call_deferred('deactivate')
		if !audio_stream_player_2d:
			return
		audio_stream_player_2d.stream = AUDIO_DEACTIVE
		audio_stream_player_2d.play()
		
func _set_active(value)->void:
	is_active = value
	print('pressure plate set active ',is_active)
	if not is_node_ready():
		return
	_refresh_active_display()
		
func _refresh_active_display()->void:
	if is_active:
		sprite_2d.frame = 40
		if 'is_active' in target:
			target.is_active = true
	else:
		sprite_2d.frame = 41
		if 'is_active' in target:
			target.is_active = false
