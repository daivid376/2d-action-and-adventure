class_name PlayerInteractionsHost extends Node2D
@onready var player: Player = $".."
@onready var movement_component : MovementComponent = self.get_parent().get_node("MovementComponent") as MovementComponent
#@onready var hit_box: HitBox = $HitBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movement_component.direction_changed.connect(update_direction)
	
	pass # Replace with function body.



func update_direction(new_dir: MovementComponent.FacingDirection)-> void:
	match new_dir:
		movement_component.FacingDirection.RIGHT:
			self.rotation_degrees = -90
		movement_component.FacingDirection.DOWN:
			self.rotation_degrees = 0
		movement_component.FacingDirection.LEFT:
			self.rotation_degrees = 90
		movement_component.FacingDirection.UP:
			self.rotation_degrees = 180
