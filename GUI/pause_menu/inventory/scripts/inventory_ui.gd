class_name InventoryUI extends Control
const INVENTORY_SLOT_UI = preload("res://GUI/pause_menu/inventory/inventory_slot_ui.tscn")
@export var data : InventoryData

func _ready() -> void:
	PauseMenuGui.shown.connect(update_inventory_ui)
	PauseMenuGui.hidden.connect(clear_inventory_ui)
	

func clear_inventory_ui()-> void:
	for c in self.get_children():
		c.queue_free()
		
func update_inventory_ui()-> void:
	if data:
		for s in data.slot_data:
			
			var new_inventory_slot_ui = INVENTORY_SLOT_UI.instantiate() as InventorySlotUI
			self.add_child(new_inventory_slot_ui)
			new_inventory_slot_ui.slot_data = s 



		
	
		
