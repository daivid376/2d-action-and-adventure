class_name Enemy extends Actor

signal died
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if state_machine:
		state_machine.state_changed.connect(_on_state_changed)
		
	pass # Replace with function body.

func _on_state_changed(current_state:State):
	if current_state is EnemyStateDying:
		current_state.died.connect(func(): died.emit(),CONNECT_ONE_SHOT)
		if hit_box:
			hit_box.monitoring = false
	pass
