class_name HeartGUI extends Control
@onready var sprite: Sprite2D = $Sprite2D

func set_heart_display(id:int)->void:
	sprite.frame = id
