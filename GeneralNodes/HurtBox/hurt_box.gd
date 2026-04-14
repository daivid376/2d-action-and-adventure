class_name HurtBox extends Area2D

signal damaged( hit_box : HitBox)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func take_damage(hit_box : HitBox)-> void:
	damaged.emit(hit_box)
	
	
