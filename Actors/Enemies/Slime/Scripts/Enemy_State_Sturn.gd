class_name EnemyStateStun extends State
@onready var enemy_state_idle: EnemyStateIdle = $"../Enemy_State_Idle"
@onready var hurt_box: HurtBox = $"../../HurtBox"

@export var knockback_speed: float = 300.
@export var decelerate_speed: float = 2000.
var is_stunned = false
var knockback_direction : Vector2

func _on_actor_assigned()->void:
	actor.damaged.connect(_on_damaged)
# Called when the node enters the scene tree for the first time.

#what happens when the playsder enters this State?
func enter()-> void:
	is_stunned = true
	actor.invulnerable = true
	
	actor.movement_component.set_direction(-knockback_direction )
	actor.movement_component.speed = -knockback_speed
	actor.movement_component.decelerate = decelerate_speed
	actor.animation_component.animation_player.animation_finished.connect(_on_anim_finished)
	actor.animation_component.set_current_state('stun')
	actor.animation_component.update_animation()
	
#what happens during the _process update in this State?
func process(_delta: float)-> State:
	if !is_stunned:
		return enemy_state_idle
	return null
#what happens when the player exit this State?
func exit()-> void:
	actor.invulnerable = false
	actor.movement_component.decelerate = 0.
	actor.animation_component.animation_player.animation_finished.disconnect(_on_anim_finished)
	pass


func _on_damaged(hit_box: HitBox)-> void:
	var hit_ower =hit_box.get_parent() as Node2D
	knockback_direction = (actor.global_position - hit_ower.global_position ).normalized()
	actor.state_machine.change_state(self)
	pass
func _on_anim_finished(anim_name: String) -> void:
	if 'stun' in anim_name:
		is_stunned = false
