class_name StateMachine extends Node

var states : Array[State]
var prev_state : State
var current_state: State
signal state_changed(current_state:State)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_state(current_state.process(delta))
func _physics_process(delta: float) -> void:
	change_state(current_state.physics_process(delta))
func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))

func init(_actor : Actor) -> void:
	states = []
	for c in get_children():
		if c is State:
			states.append(c)
			c.actor = _actor
	if states.size() > 0:
		change_state(states[0])
	set_process(true)
	set_physics_process(true)
	set_process_unhandled_input(true)

func change_state(new_state: State) -> void:
	if !new_state or new_state== current_state:
		return
	if current_state:
		current_state.exit()
	prev_state = current_state
	
	current_state = new_state
	current_state.enter()
	state_changed.emit(current_state)
	# if self.get_parent().name == 'Player':
	# 	print(current_state)
	# 	print('----')
	
