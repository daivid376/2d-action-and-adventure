class_name EnemyStateWander extends State

@export_category('AI')
@export var speed: float = 30.
@export var next_state: State
@export var state_cycles_min : int = 1
@export var state_cycles_max : int = 3
var anim_walk_length:float = 1.
var _timer: float = 0.0
@export var anim_scale: float = 1.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
#what happens when the actor enters this State?
func enter()-> void:
	var safe_anim_scale = max(anim_scale,0.01)
	set_move_random_dir()
	actor.movement_component.speed = speed
	actor.animation_component.set_current_state('walk')
	actor.animation_component.update_animation()
	actor.animation_component.animation_player.speed_scale = safe_anim_scale
	anim_walk_length = actor.animation_component.animation_player.get_animation('walk_down').length
	anim_walk_length /= safe_anim_scale
	_timer = anim_walk_length * (randi_range(state_cycles_min,state_cycles_max))
	pass
#what happens during the _process update in this State?
func process(_delta: float)-> State:
	if _timer <= 0.0:
		return next_state
	_timer -= _delta
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
func set_move_random_dir():
	var dirs = [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT]
	actor.movement_component.set_direction(dirs.pick_random())
