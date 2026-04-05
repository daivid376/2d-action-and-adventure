extends CanvasLayer
@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer
@export var anim_speed :float = 1.
@export var mute : bool = false
	
func fade_out()->void:
	if mute:
		return
	animation_player.speed_scale = anim_speed
	animation_player.play("fade_out")
	await animation_player.animation_finished
	
func fade_in()->void:
	if mute:
		return
	animation_player.speed_scale = anim_speed
	animation_player.play("fade_in")
	await animation_player.animation_finished
