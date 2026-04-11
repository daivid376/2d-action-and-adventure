class_name InventoryData extends Resource
@export var slot_data : Array[ SlotData ]

#因为 初始化的时候，拿的是默认值，不是export后赋予的值，这里会连不上
#func _init() -> void:
	#for s in slot_data:
		#if s:
			#s.emptied.connect(_on_slot_emptied)

# func setup() -> void:
# 	for s in slot_data:
# 		if s:
# 			if not s.emptied.is_connected(_on_slot_emptied):
# 				s.emptied.connect(_on_slot_emptied)

func add_item(item_data: ItemData,count : int = 1) -> bool:
	for s in slot_data:
		if s:
			if item_data == s.item_data:
				s.quantity += count
				return true
	for i in slot_data.size():
		if slot_data[i] == null:
			var new_slot = _create_slot()
			new_slot.item_data = item_data
			new_slot.quantity = count
			slot_data[i] = new_slot
			return true
	return false
	
func _create_slot()-> SlotData:
	var new_slot = SlotData.new()
	return new_slot
	

	
	
	
