@tool
class_name ItemPickup extends Node2D
@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var item_data : ItemData :set = _set_item_data

func _ready() -> void:
	_update_texture()
	if Engine.is_editor_hint():
		return
	area_2d.body_entered.connect(_on_body_entered)
	pass
	
func _on_body_entered(_body:Node)->void:
	if _body is Player:
		var picked = _body.inventory_data.add_item(self.item_data)
		if picked:
			item_pick_up()
	pass
func item_pick_up()->void:
	area_2d.body_entered.disconnect(_on_body_entered)
	audio_stream_player_2d.play()
	self.visible = false
	await audio_stream_player_2d.finished
	self.queue_free()


func _set_item_data(value: ItemData)-> void:
	item_data = value
	_update_texture()

func _update_texture()->void:
	if !sprite_2d or !item_data:
		return
	sprite_2d.texture = item_data.texture
