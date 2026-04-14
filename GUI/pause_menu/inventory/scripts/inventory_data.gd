class_name InventoryData extends Resource
@export var slot_data : Array[ Slot ]
#因为 初始化的时候，拿的是默认值，不是export后赋予的值，这里会连不上
signal slots_rebuilt

func setup() -> void:
	SaveManager.register_savable(self,'player_inventory')
	_rebuild_slots()

func add_item(item_data: Item,count : int = 1) -> bool:
	for s in slot_data:
		if not s.is_empty():
			if item_data == s.item_data:
				s.add_quantity(count)
				return true
	for s in slot_data:
		if s.is_empty():
			s.set_item(item_data,count)
			return true
	return false

func _rebuild_slots()-> void:
	for i in slot_data.size():
		if slot_data[i] == null:
			slot_data[i] = _create_slot()
		slot_data[i].index = i
	slots_rebuilt.emit()
	print('rebuild slots')


func _create_slot()-> Slot:
	var new_slot := Slot.new() as Slot
	return new_slot
	
func to_save_data()-> Array:
	var save_data : Array =[]
	for s in slot_data:
		save_data.append(_slot_to_save(s))
	return save_data

func _slot_to_save(slot: Slot)-> Dictionary:
	var result := {'item_res_path':'','quantity' : 0,}
	if not slot.is_empty():
		result['quantity'] = slot.quantity
		if slot.item_data:
			result['item_res_path'] = slot.item_data.resource_path
	return result
	
func from_save_data(data:Array):
	var saved_data : Array = data
	var data_size :int = saved_data.size()
	if slot_data.size() != data_size:
		slot_data.resize(data_size)
		_rebuild_slots()
	for i in saved_data.size():
		_apply_save_data(slot_data[i],saved_data[i])

func _apply_save_data(slot_to_set:Slot,saved_data:Dictionary):
	var item_res_path : String = saved_data['item_res_path']
	if not item_res_path.is_empty():
		print('when loading,saved data :', saved_data)
		var load_item := ResourceLoader.load(item_res_path) as Item
		slot_to_set.set_item(load_item,saved_data['quantity'])
	else:
		slot_to_set.clear()
	
	
	
