class_name Plant extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HurtBox.damaged.connect(take_damage)
	pass # Replace with function body.


func take_damage(_hit_box: HitBox) -> void:
	self.queue_free()
