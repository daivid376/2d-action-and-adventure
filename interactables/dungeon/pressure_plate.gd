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

@export var target : Node
func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)
	pass
	
func _on_body_entered(_body)->void:
	interacting_body_count += 1
	update_active_state()
	
func _on_body_exited(_body)->void:
	interacting_body_count -= 1
	update_active_state()
	
func update_active_state()->void:
	if interacting_body_count > 0 and not is_active:
		is_active = true
		sprite_2d.frame = 40
		audio_stream_player_2d.stream = AUDIO_ACTIVE
		audio_stream_player_2d.play()
		activated.emit()
		if target and target.has_method('activate'):
			target.activate()
	if interacting_body_count == 0 and is_active:
		is_active = false
		sprite_2d.frame = 41
		audio_stream_player_2d.stream = AUDIO_DEACTIVE
		audio_stream_player_2d.play()
		deactivated.emit()
		if target and target.has_method('deactivate'):
			target.deactivate()
		
		
