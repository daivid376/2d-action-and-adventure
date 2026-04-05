class_name MovementComponent extends Node

const SAVE_FIELDS :Array = ['cardinal_direction']
enum FacingDirection {UP,DOWN,RIGHT,LEFT}
var cardinal_direction: FacingDirection = FacingDirection.DOWN:
	set(_v):
		cardinal_direction = _v
		direction_changed.emit(cardinal_direction)
signal direction_changed(new_dir : FacingDirection)
var _direction : Vector2 = Vector2.ZERO
var _speed :float = 0.0
var _decelerate : float = 0.0
@onready var parent : Actor = self.get_parent() as Actor

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	print('parent.can_be_saved()',parent.can_be_saved())
	if parent is Actor and parent.can_be_saved() :
		SaveManager.register_savable(self,self.parent.name + '.movement_component')
		print(SaveManager.save_registry)

func _physics_process(_delta: float) -> void:
	if !parent:
		return
	var velocity = _direction * _speed
	_speed =  max((abs(_speed) - _decelerate* _delta) ,0.) * sign(_speed)
	# if _decelerate>0.01 and parent.name == 'Player':
	# 	print('_decelerate: ', _decelerate)
	# 	print('_speed: ', _speed)
	# 	print('velocity: ', velocity)

	parent.velocity = velocity
	parent.move_and_slide()

func get_animation_direction_name() -> String:
	var dir_name:String = FacingDirection.find_key(cardinal_direction).to_lower()
	dir_name = 'side' if dir_name in['left','right'] else dir_name
	return dir_name

var speed:float:
	get:
		return _speed
	set(value):
		_speed = value
var decelerate: float:
	get:
		return _decelerate
	set(value):
		_decelerate = value
func stop() -> void:
	_direction = Vector2.ZERO
	_speed = 0.0



func set_direction(input_dir: Vector2) -> void:
	if _direction == input_dir:
		return
	_direction = input_dir
	# if self.get_parent().name == 'Player':
	# 	print('Direction set to: ', _direction)
	update_direction()
func get_direction() -> Vector2:
	return _direction
func update_direction() -> bool:
	if _direction == Vector2.ZERO:
		return false
	var new_cardinal_dir : FacingDirection = FacingDirection.DOWN
	if abs(_direction.x) > abs(_direction.y):
		new_cardinal_dir = FacingDirection.RIGHT if _direction.x > 0.0 else FacingDirection.LEFT
	else:
		new_cardinal_dir = FacingDirection.DOWN if _direction.y >0.0 else FacingDirection.UP
	if new_cardinal_dir == cardinal_direction:
		return false
	else:
		cardinal_direction = new_cardinal_dir
		return true
	
