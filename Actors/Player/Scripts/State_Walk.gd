class_name StateWalk extends State
@export var speed :float = 200.0
@onready var state_idle: StateIdle = $"../Idle"
@onready var state_attack: StateAttack = $"../Attack"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
#what happens when the actor enters this State?
func enter()-> void:
	actor.animation_component.set_current_state('walk')
	actor.animation_component.update_animation()
	pass
#what happens during the _process update in this State?
func process(_delta: float)-> State:
	if Input.is_action_just_pressed("attack"):
		return state_attack
	return null
#what happens when the actor exit this State?
func exit()-> void:
	pass

#what happens during the _physics_process update in this State?
func physics_process(_delta: float)-> State:
	if actor.input_direction == Vector2.ZERO:
		return state_idle
	actor.movement_component.set_direction(actor.input_direction)
	actor.movement_component.speed = speed
	return null

#what happens with input events in this State?
func handle_input(_event: InputEvent)-> State:
	
	return null
