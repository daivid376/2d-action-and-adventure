class_name Inventory extends Resource
@export var slots : Array[ Slot ]
#因为 初始化的时候，拿的是默认值，不是export后赋予的值，这里会连不上
signal slots_rebuilt

func setup() -> void:
	_rebuild_slots()

func add_item(item: Item,count : int = 1) -> bool:
	for s in slots:
		if not s.is_empty():
			if item == s.item:
				s.add_quantity(count)
				return true
	for s in slots:
		if s.is_empty():
			s.set_item(item,count)
			return true
	return false
	
func use_item(item: Item, count : int = 1) -> bool:
	if item:
		for s in slots:
			if s.item == item:
				if s.use_slot(count):
					return true
	return false
func consume_item(item : Item, count : int = 1) -> bool:
	if item:
		for s in slots:
			if s.item == item:
				if s.consume_quantity(count):
					return true
	return false
func has_item(item: Item) -> bool:
	if item:
		for s in slots:
			if s.item == item:
				return true
	return false
	
func _rebuild_slots()-> void:
	for i in slots.size():
		if slots[i] == null:
			slots[i] = _create_slot()
		slots[i].index = i
	slots_rebuilt.emit()


func _create_slot()-> Slot:
	var new_slot := Slot.new() as Slot
	return new_slot
	
func to_persistent_data()-> Array:
	var slots_to_save : Array =[]
	for s in slots:
		slots_to_save.append(_slot_to_save(s))
	return slots_to_save

func _slot_to_save(slot: Slot)-> Dictionary:
	var slot_save_payload := {'item_res_path':'','quantity' : 0,}
	if not slot.is_empty():
		slot_save_payload['quantity'] = slot.quantity
		if slot.item:
			slot_save_payload['item_res_path'] = slot.item.resource_path
	return slot_save_payload
	
func from_persistent_data(saved_slots:Array):
	var data_size :int = saved_slots.size()
	if slots.size() != data_size:
		slots.resize(data_size)
		_rebuild_slots()
	for i in saved_slots.size():
		_apply_saved_slots(slots[i],saved_slots[i])

func _apply_saved_slots(slot_to_set:Slot,saved_slots:Dictionary):
	var item_res_path : String = saved_slots['item_res_path']
	if not item_res_path.is_empty():
		var load_item := ResourceLoader.load(item_res_path) as Item
		slot_to_set.set_item(load_item,saved_slots['quantity'])
	else:
		slot_to_set.clear()
	
	
	
