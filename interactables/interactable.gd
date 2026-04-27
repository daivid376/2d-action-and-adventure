class_name Interactable extends Node
var can_interact :bool = true

var persistent_state_properties : Array[StringName] = [] #['cheset_state','door_state']

#virtual
func interact()->void:
	pass
#virtual
func get_persistent_state_properties() -> Array[StringName]:
	return []

func to_persistent_data() -> Dictionary:
	var data := {}
	for property_name in get_persistent_state_properties():
		if property_name in self:
			data[property_name] = self.get(property_name)
	print('to persistent data, ', data)
	return data

func from_persistent_data(data: Dictionary) -> void:
	print('from_persistent_data ', data)
	for property_name in get_persistent_state_properties():
		print('property_name ',property_name)
		if data.has(property_name):
			print('set value ',data[property_name])
			self.set(property_name,data[property_name])
	
	
		
