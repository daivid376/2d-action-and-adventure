class_name InventorySlotUI extends Button

var slot_data : Slot: set = set_slot_data

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
	if slot_data:
		if slot_data.slot_changed.is_connected(_refresh_ui):
			slot_data.slot_changed.disconnect(_refresh_ui)
	
	slot_data = value
	
	if slot_data and not slot_data.slot_changed.is_connected(_refresh_ui):
		slot_data.slot_changed.connect(_refresh_ui)

	_refresh_ui()
	pass

func update_item_description_label()-> void:
	var item_description = ''
	if !self.slot_data.is_empty():
		item_description =self.slot_data.item_data.description
	else:
		item_description = ''
	PauseMenuGui.update_item_description(item_description)

func clear_item_description_label()-> void:
	PauseMenuGui.update_item_description('')

func item_pressed() -> void:
	print("pressed: ", self, " id=", get_instance_id(), " path=", get_path())
	if !self.slot_data.is_empty():
		var used : bool =  self.slot_data.item_data.use()
		if used:
			self.slot_data.use_slot(1)

func _refresh_ui()-> void:
	if !slot_data or slot_data.is_empty():
		texture_rect.texture = null
		label.text = ''
		return
	if !self.slot_data.is_empty():
		self.texture_rect.texture = slot_data.item_data.texture
	self.label.text = str(slot_data.quantity)

#func _on_slot_emptied()->void:
	#self.slot_data.is_empty = true
	#_refresh_ui()
