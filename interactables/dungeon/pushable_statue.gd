class_name Pushable_Statue extends RigidBody2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var push_direction : Vector2 = Vector2.ZERO : set = _set_push
var speed :float = 30.
const PERSISTENT_FIELDS := ['global_position']
func _enter_tree() -> void:
	#collision_shape_2d.set_deferred('disabled',true)
	pass
func _exit_tree() -> void:
	print('pushable exit')
func _ready() -> void:
	pass
	#collision_shape_2d.set_deferred('disabled',false)
	#LevelManager.level_load_started.connect(_disable_collision)
	#LevelManager.level_loaded.connect(_enable_collision)

func _physics_process(_delta: float) -> void:
	linear_velocity = push_direction * speed
	
func _set_push(value)->void:
	push_direction = value
func _disable_collision()->void:
	collision_shape_2d.set_deferred('disabled',true)

func _enable_collision()->void:
	await get_tree().process_frame
	collision_shape_2d.set_deferred('disabled',false)
