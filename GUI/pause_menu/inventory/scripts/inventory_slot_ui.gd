class_name InventorySlotUI extends Button

var slot_data : SlotData: set = set_slot_data

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
	
func set_slot_data(value: SlotData)-> void:
	slot_data = value
	if slot_data:
		if slot_data.quantity < 1:
			slot_data = null
		elif !slot_data.emptied.is_connected(_on_slot_emptied):
			slot_data.emptied.connect(_on_slot_emptied)
	_refresh_ui()
	pass

func update_item_description_label()-> void:
	var item_description = ''
	if self.slot_data and self.slot_data.item_data:
		item_description =self.slot_data.item_data.description
	else:
		item_description = ''
	PauseMenuGui.update_item_description(item_description)

func clear_item_description_label()-> void:
	PauseMenuGui.update_item_description('')

func item_pressed() -> void:
	print("pressed: ", self, " id=", get_instance_id(), " path=", get_path())
	if self.slot_data and self.slot_data.item_data:
		var used : bool =  self.slot_data.item_data.use()
		if used:
			self.slot_data.quantity -= 1
			_refresh_ui()
	pass

func _refresh_ui()-> void:
	if !slot_data:
		texture_rect.texture = null
		label.text = ''
		return
	if self.slot_data and self.slot_data.item_data:
		self.texture_rect.texture = slot_data.item_data.texture
	self.label.text = str(slot_data.quantity)

func _on_slot_emptied()->void:
	print('_on_slot_emptied at inventory slot ui')
	self.slot_data = null
	#_refresh_ui()
