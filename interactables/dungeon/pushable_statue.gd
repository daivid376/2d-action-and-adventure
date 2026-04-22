class_name Pushable_Statue extends RigidBody2D
var push_direction : Vector2 = Vector2.ZERO : set = _set_push
var speed :float = 30.


func _physics_process(delta: float) -> void:
	linear_velocity = push_direction * speed
	
func _set_push(value)->void:
	push_direction = value
