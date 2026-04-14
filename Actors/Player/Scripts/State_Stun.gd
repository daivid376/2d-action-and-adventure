class_name StateStun extends State
@onready var state_idle: StateIdle = $"../Idle"
@onready var state_walk: StateWalk = $"../Walk"
@onready var state_attack: StateAttack = $"../Attack"
@export var knockback_speed:float = 300.
@export var knockback_decelerate:float = 2000.
var knockback_dir: Vector2
var is_stunned:bool = false
func _on_actor_assigned()->void:
	actor.hurt_box.damaged.connect(_on_damaged)

#what happens when the actor enters this State?
func enter()-> void:
	is_stunned = true
	actor.movement_component.set_direction(knockback_dir)
	actor.movement_component.speed = -knockback_speed
	actor.movement_component.decelerate = knockback_decelerate
	actor.animation_component.set_current_state('stun')
	actor.animation_component.update_animation()
	actor.animation_component.animation_player.animation_finished.connect(_on_anim_finished)
	
	pass
#what happens during the _process update in this State?
func process(_delta: float)-> State:
	if !is_stunned:
		return state_idle
	return null
#what happens when the actor exit this State?
func exit()-> void:
	actor.movement_component.decelerate = 0.
	actor.animation_component.animation_player.animation_finished.disconnect(_on_anim_finished)
	pass

#what happens during the _physics_process update in this State?
func physics_process(_delta: float)-> State:

	return null

func _on_damaged(hit_box: HitBox)->void:
	knockback_dir = actor.global_position.direction_to(hit_box.global_position)
	actor.state_machine.change_state(self)
	return
func _on_anim_finished(anim_name:String) -> void:
	if 'stun' in anim_name:
		is_stunned = false
