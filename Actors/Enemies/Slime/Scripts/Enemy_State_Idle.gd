class_name EnemyStateIdle extends State

@export_category('AI')
@export var state_duration_min: float = 0.5
@export var state_duration_max: float = 1.5
@export var after_idle_state: State

var _timer: float = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
#what happens when the actor enters this State?
func enter()-> void:
	actor.movement_component.stop()
	actor.animation_component.set_current_state('idle')
	actor.animation_component.update_animation()
	
	_timer = randf_range(state_duration_min,state_duration_max)
	pass
#what happens during the _process update in this State?
func process(_delta: float)-> State:
	_timer -= _delta
	if _timer <= 0.0:
		return after_idle_state
	return null
#what happens when the actor exit this State?
func exit()-> void:
	pass

#what happens during the _physics_process update in this State?
func physics_process(_delta: float)-> State:

	return null

#what happens with input events in this State?
func handle_input(_event: InputEvent)-> State:

	return null
