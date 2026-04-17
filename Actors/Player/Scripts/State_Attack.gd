class_name StateAttack extends State

@onready var state_walk: StateWalk = $"../Walk"
@onready var state_idle: StateIdle = $"../Idle"
@onready var attack_fx_animation_player: AnimationPlayer = $"../../Sprite2D/Sprite_AttackFX/AnimationPlayer"
@onready var audio_stream_player: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var hit_box: HitBox = $"../../Interactions/HitBox"

var is_attacking : bool = false

@export var attack_audio: AudioStream
@export_range(1.,2000.,1) var attack_decelerate:float = 2000
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
#what happens when the player enters this State?
func enter()-> void:
	actor.animation_component.set_current_state('attack')
	actor.animation_component.update_animation()
	attack_fx_animation_player.play("attack_" + actor.movement_component.get_animation_direction_name())
	is_attacking = true
	if not actor.animation_player.animation_finished.is_connected(_on_attack_finished):
		actor.animation_player.animation_finished.connect(_on_attack_finished)
	if attack_audio:
		audio_stream_player.stream = attack_audio
		audio_stream_player.pitch_scale = randf_range(0.8,1.2)
		audio_stream_player.play()
	
	await get_tree().create_timer(0.025).timeout
	if is_attacking:
		hit_box.monitoring = true

#what happens during the _process update in this State?
func process(_delta: float)-> State:

	return null
#what happens when the actor exit this State?
func exit()-> void:
	if actor.animation_player.animation_finished.is_connected(_on_attack_finished):
		actor.animation_player.animation_finished.disconnect(_on_attack_finished)
	hit_box.monitoring = false
	is_attacking = false

#what happens during the _physics_process update in this State?
func physics_process(_delta: float)-> State:
	if !is_attacking:
		actor.movement_component.decelerate = 0.
		if actor.input_direction != Vector2.ZERO:
			return state_walk
		else:
			return state_idle
	else:
		actor.movement_component.decelerate = attack_decelerate
	return null

#what happens with input events in this State?
func handle_input(_event: InputEvent)-> State:
	
	return null
func _on_attack_finished(anim_name:StringName)-> void:
	if 'attack' in anim_name:
		is_attacking = false
