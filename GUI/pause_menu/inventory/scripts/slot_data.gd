class_name Slot extends Resource
@export var item : Item
@export var quantity : int : set = _set_quantity


var index : int = -1
signal slot_changed

func set_item(new_item: Item,new_quantity: int):
	self.item = new_item
	self.quantity = max(new_quantity,0)
	if self.is_empty():
		self.clear()
	slot_changed.emit()
	

func use_slot(count:int = 1)->void:
	quantity -= count
	slot_changed.emit()
	
func add_quantity(count:int = 1)->void:
	quantity += count
	slot_changed.emit()
	
func _set_quantity(value : int)->void:
	quantity = max(value,0)
	if quantity == 0:
		item = null
#func _set_item_data(value: Item)->void:
	#item = value
	#slot_changed.emit()

func is_empty()->bool:
	return item == null or quantity == 0

func clear()-> void:
	item = null
	quantity = 0
	slot_changed.emit()
	


	
