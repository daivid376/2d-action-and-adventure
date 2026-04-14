class_name BaseStunState extends State
@export var knockback_speed:float = 300.
@export var knockback_decelerate:float = 2000.
@export var invulnerable_time : float = 0.5
@export var next_state : State
var knockback_dir: Vector2
var is_stunned:bool = false

func _on_actor_assigned()->void:
	actor.damaged.connect(_on_damaged)
# Called when the node enters the scene tree for the first time.
func enter()->void:
	is_stunned = true
	actor.movement_component.set_direction(knockback_dir)
	actor.movement_component.speed = -knockback_speed
	actor.movement_component.decelerate = knockback_decelerate
	actor.animation_component.set_current_state('stun')
	actor.animation_component.update_animation()
	actor.animation_component.animation_player.animation_finished.connect(_on_destroy_anim_finished)
	actor.make_invulnerable(invulnerable_time)
func process(_delta: float)-> State:
	if !is_stunned:
		return next_state
	return null
	
func exit()-> void:
	actor.movement_component.decelerate = 0.
	actor.animation_component.animation_player.animation_finished.disconnect(_on_destroy_anim_finished)
	pass
	
func _on_damaged(hit_box: HitBox)->void:
	knockback_dir = actor.global_position.direction_to(hit_box.global_position)
	actor.state_machine.change_state(self)
	return
func _on_destroy_anim_finished(anim_name:String) -> void:
	if 'stun' in anim_name:
		is_stunned = false
