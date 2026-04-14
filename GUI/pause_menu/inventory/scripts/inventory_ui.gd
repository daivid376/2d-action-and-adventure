class_name InventoryUI extends Control
const INVENTORY_SLOT_UI = preload("res://GUI/pause_menu/inventory/inventory_slot_ui.tscn")
@export var data : InventoryData

#const SAVE_FIELDS:Array = ['data']
func _ready() -> void:
	data.slots_rebuilt.connect(update_inventory_ui)
	data.setup()

func clear_inventory_ui()-> void:
	for c in self.get_children():
		c.queue_free()
		
func update_inventory_ui()-> void:
	if data:
		var children_count = self.get_child_count()
		var slots_cout = data.slot_data.size()
		
		#for i in range(min(slots_cout,children_count)):
			#var child_node := self.get_child(i) as InventorySlotUI
			#child_node.slot_data = data.slot_data[i]
			
		for i in range(children_count,slots_cout):
			var new_slot_ui = INVENTORY_SLOT_UI.instantiate() as InventorySlotUI
			self.add_child(new_slot_ui)
			new_slot_ui.slot_data = data.slot_data[i]
			
		for i in range(children_count - 1, slots_cout - 1,-1):
			self.get_child(i).queue_free()
		


		
	
		
