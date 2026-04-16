class_name Level extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.y_sort_enabled = true
	LevelManager.level_load_started.connect(_free_level)
	PlayerManager.set_player_parent(self)


func _free_level()->void:
	PlayerManager.unparent_player()
	queue_free()
	
	pass
