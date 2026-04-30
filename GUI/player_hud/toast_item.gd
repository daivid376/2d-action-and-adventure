class_name ToastItem
extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $AnimationRoot/PanelContainer/MarginContainer/HBoxContainer/Label
@onready var texture_rect: TextureRect = $AnimationRoot/PanelContainer/MarginContainer/HBoxContainer/TextureRect

@export var slide_distance := 20.0
@export var in_duration := 0.18
@export var hold_duration := 0.8
@export var out_duration := 0.5

func setup(text: String,icon : Texture2D = null) -> void:
	label.text = text
	texture_rect.texture = icon
	texture_rect.visible = icon != null

func play() -> void:
	animation_player.play("show")
	await animation_player.animation_finished
	queue_free()
	pass
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	#modulate.a = 0.0
#
	#var final_pos := position
	#var start_pos := final_pos
#
	#match edge:
		#"right":
			#start_pos.x += slide_distance
		#"left":
			#start_pos.x -= slide_distance
		#"top":
			#start_pos.y -= slide_distance
		#"bottom":
			#start_pos.y += slide_distance
#
	#position = start_pos
#
	#var tween := create_tween()
	#tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	#tween.set_trans(Tween.TRANS_CUBIC)
	#tween.set_ease(Tween.EASE_OUT)
#
	#tween.tween_property(self, "position", final_pos, in_duration + hold_duration + out_duration)
	#tween.parallel().tween_property(self, "modulate:a", 1.0, in_duration)
#
	#tween.tween_interval(hold_duration)
#
	#tween.set_ease(Tween.EASE_IN)
	##tween.tween_property(self, "position", start_pos, out_duration)
	#tween.parallel().tween_property(self, "modulate:a", 0.0, out_duration)
#
	#tween.tween_callback(queue_free)
