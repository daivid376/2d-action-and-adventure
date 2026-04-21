@tool
class_name Chest extends Interactable
enum ChestState {CLOSED,OPENED}

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interaction_area: Area2D = $InteractionArea
@onready var item_sprite: Sprite2D = $ItemSprite
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $ItemSprite/Label


@export var item : Item : set = _set_item
@export var quantity : int  = 1 : set = _set_quantity
@export var chest_state := ChestState.CLOSED : set = _set_chest_state
#var persistent_states:= ['chest_state']
#signal state_changed()
#const INVENTORY := preload("res://GUI/pause_menu/inventory/player_inventory.tres")
var is_opened :bool = false

func _ready() -> void:
	super()
	_update_texture()
	_update_label()
	_update_chest_state()
	print('chest_ready')
	if Engine.is_editor_hint():
		return
	item_sprite.visible = false
	#restore_persistent_states()

func interact()->void:
	if chest_state != ChestState.CLOSED:
		return
	chest_state = ChestState.OPENED
	capture_persistent_states()
	if quantity > 0 and item:
		PlayerManager.INVENTORY.add_item(item,quantity)
		item_sprite.visible = true
		animation_player.play("open")
		audio_stream_player_2d.play()
	else:
		push_error('chest empty')
	
#func apply_persistent_state() -> void:
	#var stored_state : Dictionary = WorldState.get_object_state(persistent_id)
	#print('stored_state ',stored_state)
	#if 'chest_state' in stored_state:
		#_set_chest_state(stored_state['chest_state'])

#func capture_persistent_state() -> void:
	#WorldState.set_object_state(persistent_id,{'chest_state':chest_state})

func _set_item(value : Item)-> void:

	item = value
	_update_texture()
	
func _set_quantity(value : int)->void:
	quantity = value
	_update_label()

func _update_texture()->void:
	if !item_sprite or !item :
		return 
	item_sprite.texture = item.texture
func _update_label()->void:
	if !label:
		return
	if quantity > 1:
		self.label.text = 'x' + str(quantity)
	else:
		self.label.text =  ''
func _set_chest_state(value : ChestState)->void:
	chest_state = value
	states['chest_state'] = value
	if !sprite_2d:
		return
	_update_chest_state()
	
func _update_chest_state()->void:
	match chest_state:
		ChestState.CLOSED:
			sprite_2d.frame = 0
		ChestState.OPENED:
			sprite_2d.frame = 1
