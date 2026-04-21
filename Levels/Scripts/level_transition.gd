@tool
class_name LevelTransition extends Area2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

enum Side {LEFT,RIGHT,TOP,BOTTOM}
@export_file('*.tscn') var level_to_load :String = ''
@export var target_transition_area : String = 'LevelTransition'

@export_category('collision area settings')
@export_range(1,12,1,'or_greater') var size: int = 2:
	set(_v):
		size = _v
		_update_area()
@export var side : LevelTransition.Side = Side.LEFT:
	set(_v):
		side = _v
		_update_area()
@export var snap_to_grid: bool = false:
	set(_v):
		_snap_to_grid()

const OFFSET_AMOUNT: float = 30.
#var can_trigger : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint():
		return
	body_entered.connect(_player_entered)

func _player_entered(_body: Node2D)-> void:
	if _body is Player:
		LevelManager.load_new_level_by(self)
		
func get_transition_target_position(from_level_transition_position : Vector2, from_level_transition_size : int)->Vector2:
	var player_offset: Vector2 = Vector2.ZERO
	var player_pos : Vector2 = PlayerManager.player.global_position
	var scale_ratio : float = float(self.size) / float(from_level_transition_size)
	var _offset :float = OFFSET_AMOUNT if side in [Side.LEFT,Side.TOP] else -OFFSET_AMOUNT
	
	#if side in [Side.LEFT,Side.RIGHT]:
		#player_offset.x = self.global_position.x - player_pos.x + _offset
	#else:
		#player_offset.y = self.global_position.y - player_pos.y + _offset
	var _channel :int = 0 if side in [Side.LEFT,Side.RIGHT] else 1
	player_offset[_channel] = _offset
	var result := (player_pos - from_level_transition_position) * scale_ratio + self.global_position + player_offset
	return result
	
func _update_area()->void:
	var new_rect: Vector2 = Vector2(32,32)
	var new_pos : Vector2 = Vector2.ZERO
	match side:
		Side.LEFT:
			new_rect.y *= size 
			new_pos.x -= new_rect.x *0.5
		Side.RIGHT:
			new_rect.y *= size 
			new_pos.x += new_rect.x *0.5
		Side.TOP:
			new_rect.x *= size
			new_pos.y -= new_rect.y *0.5
		Side.BOTTOM:
			new_rect.x *= size 
			new_pos.y += new_rect.y *0.5
			
	if !collision_shape:
		collision_shape = self.get_node('CollisionShape2D')
	collision_shape.shape.size = new_rect
	collision_shape.position = new_pos
	pass
func _snap_to_grid()->void:
	#position = position.snapped(Vector2(16,16))
	for i in range(2):
		position[i] = round(position[i]/16) *16
	pass
