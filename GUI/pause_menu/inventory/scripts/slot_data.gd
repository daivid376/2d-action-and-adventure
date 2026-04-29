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

func use_slot(count:int = 1)->bool:
	if count > 0 and quantity >= count and item.use(count):
		consume_quantity(count)
		return true
	return false
	
func add_quantity(count:int = 1)->void:
	if count <= 0:
		return
	quantity += count
	print('add item')

func consume_quantity(count:int = 1)-> bool:
	if count <= 0:
		return false
	elif count > quantity:
		return false
	else:
		quantity -= count
		return true
	
func _set_quantity(value : int)->void:
	if quantity == max(value,0):
		return
	quantity = max(value,0)
	if quantity == 0:
		item = null
	slot_changed.emit()
	
#func _set_item_data(value: Item)->void:
	#item = value
	#slot_changed.emit()

func is_empty()->bool:
	return item == null or quantity == 0

func clear()-> void:
	item = null
	quantity = 0
	


	
