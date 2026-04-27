class_name OpenableInteractable extends Interactable

@export var is_opened : bool = false :set = _set_is_opened

func interact()->void:
	if not can_interact:
		return
	if is_opened:
		return
	on_interacted()
	
#virtural
func on_interacted() -> void:
	pass

#virtural
func _refresh_open_state()->void:
	pass

func _set_is_opened(value) ->void:
	is_opened = value
	if is_node_ready():
		_refresh_open_state()
	
func get_persistent_state_properties() -> Array[StringName]:
	var properties = super.get_persistent_state_properties()
	properties.append(&'is_opened')
	return properties
