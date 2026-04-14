class_name EnemyStateDestroy extends BaseStunState
@onready var destroy_animation_player: AnimationPlayer = $"../../DestroyEffectSprite/AnimationPlayer"

signal start_destroy
# Called when the node enters the scene tree for the first time.
func _on_actor_assigned()->void:
	actor.died.connect(_on_died)

func enter()-> void:
	super()
	start_destroy.emit()
	destroy_animation_player.play('destroy')
	destroy_animation_player.animation_finished.connect(_on_destroy_anim_finished)
	if actor.loot_component:
		actor.loot_component.drop()
	
	
#what happens during the _process update in this State?
func process(_delta: float)-> State:
	return null
#what happens when the player exit this State?
func exit()-> void:
	super()
	destroy_animation_player.animation_finished.disconnect(_on_destroy_anim_finished)

func _on_died(hit_box:HitBox)-> void:
	super._on_damaged(hit_box)

func _on_destroy_anim_finished(anim_name: String) -> void:
	if 'destroy' in anim_name:
		actor.movement_component.decelerate = 0.
		actor.queue_free()
