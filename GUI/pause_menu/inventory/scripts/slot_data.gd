class_name SlotData extends Resource
@export var item_data : ItemData
@export var quantity : int : set = _set_quantity
signal emptied()

func _set_quantity(value : int)->void:
	quantity = value
	if quantity < 1:
		emptied.emit()
