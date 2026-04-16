@tool
class_name ItemPickup extends CharacterBody2D
@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var movement_component: MovementComponent = $MovementComponent
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var item : Item :set = _set_item_data

var pending_drop_speed:float  =0.
var pending_drop_dir:Vector2 = Vector2.ZERO
var pending_deceleration:float = 0.
var play_drop_animation_on_ready: bool = false
var rand_index:int = 0
func _ready() -> void:
	_update_texture()
	if Engine.is_editor_hint():
		return
	area_2d.body_entered.connect(_on_body_entered)
	if play_drop_animation_on_ready:
		animation_player.play('drop_item')
		var anim_speed_rand = GoldenSeq.rand_around(rand_index,1.2,0.15)
		animation_player.speed_scale = anim_speed_rand
		movement_component.speed = pending_drop_speed
		movement_component.set_direction(pending_drop_dir)
		movement_component.decelerate = pending_deceleration
	else:
		movement_component.process_mode = Node.PROCESS_MODE_DISABLED

	pass
func _physics_process(_delta: float) -> void:
	#move_and_slide()
	pass
func _on_body_entered(_body:Node)->void:
	if _body is Player:
		var picked = _body.inventory.add_item(self.item)
		if picked:
			item_pick_up()
	pass
func item_pick_up()->void:
	area_2d.body_entered.disconnect(_on_body_entered)
	audio_stream_player_2d.play()
	self.visible = false
	await audio_stream_player_2d.finished
	self.queue_free()


func _set_item_data(value: Item)-> void:
	item = value
	_update_texture()

func _update_texture()->void:
	if !sprite_2d or !item:
		return
	sprite_2d.texture = item.texture
