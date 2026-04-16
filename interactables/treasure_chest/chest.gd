@tool
class_name Chest extends Interactable

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interaction_area: Area2D = $InteractionArea
@onready var item_sprite: Sprite2D = $ItemSprite
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $ItemSprite/Label

@export var item : Item : set = _set_item
@export var quantity : int  = 1 : set = _set_quantity
#const INVENTORY := preload("res://GUI/pause_menu/inventory/player_inventory.tres")
var is_opened :bool = false
func _ready() -> void:
	_update_texture()
	_update_label()
	if Engine.is_editor_hint():
		return
	item_sprite.visible = false
	pass

func interact()->void:
	if is_opened:
		return
	is_opened = true
	item_sprite.visible = true
	animation_player.play("open")
	audio_stream_player_2d.play()
	print('try open')
	if quantity > 0:
		PlayerManager.INVENTORY.add_item(item,quantity)
	else:
		push_error('chest empty')
func _set_item(value : Item)-> void:
	print("set_item, value=", value, " ready=", is_node_ready(), " item_sprite=", item_sprite)
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
