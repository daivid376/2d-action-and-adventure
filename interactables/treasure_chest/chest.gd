@tool
class_name Chest extends OpenableInteractable
enum ChestState {CLOSED,OPENED}

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interaction_area: Area2D = $InteractionArea
@onready var item_sprite: Sprite2D = $ItemSprite
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $ItemSprite/Label


@export var item : Item : set = _set_item
@export var quantity : int  = 1 : set = _set_quantity
#const INVENTORY := preload("res://GUI/pause_menu/inventory/player_inventory.tres")


func _ready() -> void:
	_update_texture()
	_update_label()
	_refresh_open_state()
	if Engine.is_editor_hint():
		return
	item_sprite.visible = false
	#restore_persistent_states()

func on_interacted() -> void:
	#capture_persistent_states()
	is_opened = true
	if quantity > 0 and item:
		PlayerManager.INVENTORY.add_item(item,quantity)
		item_sprite.visible = true
		animation_player.play("open")
		audio_stream_player_2d.play()
	else:
		push_error('chest empty')
	

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
	
func _refresh_open_state()->void:
	if is_opened:
		sprite_2d.frame = 1
	else:
		sprite_2d.frame = 0
