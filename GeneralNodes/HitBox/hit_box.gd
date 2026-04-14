class_name HitBox extends Area2D
@export var damage : float = 1.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	pass # Replace with function body.


func _on_area_entered(other_area: Area2D)-> void:
	if other_area is HurtBox:
		other_area.take_damage(self)
