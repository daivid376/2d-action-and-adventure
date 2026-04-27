class_name InventorySlotUI extends Button

var slot : Slot: set = set_slot_data

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

func _ready() -> void:
	texture_rect.texture = null
	label.text = ''
	focus_entered.connect(update_item_description_label)
	focus_exited.connect(clear_item_description_label)
	mouse_entered.connect(update_item_description_label)
	mouse_exited.connect(clear_item_description_label)
	pressed.connect(item_pressed)

	
func set_slot_data(value: Slot)-> void:
	if slot:
		if slot.slot_changed.is_connected(_refresh_ui):
			slot.slot_changed.disconnect(_refresh_ui)
	
	slot = value
	
	if slot and not slot.slot_changed.is_connected(_refresh_ui):
		slot.slot_changed.connect(_refresh_ui)

	_refresh_ui()
	pass

func update_item_description_label()-> void:
	var item_description = ''
	if !self.slot.is_empty():
		item_description =self.slot.item.description
	else:
		item_description = ''
	PauseMenuGui.update_item_description(item_description)

func clear_item_description_label()-> void:
	PauseMenuGui.update_item_description('')

func item_pressed() -> void:
	if !self.slot.is_empty():
		slot.use_slot(1)

func _refresh_ui()-> void:
	if !slot or slot.is_empty():
		texture_rect.texture = null
		label.text = ''
		return
	if !self.slot.is_empty():
		self.texture_rect.texture = slot.item.texture
	self.label.text = str(slot.quantity)

#func _on_slot_emptied()->void:
	#self.slot.is_empty = true
	#_refresh_ui()
