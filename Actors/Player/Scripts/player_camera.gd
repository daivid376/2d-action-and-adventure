class_name PlayerCamera extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	LevelManager.tilemap_bounds_changed.connect(set_camera_limit)
	LevelManager.level_load_started.connect(func():self.position_smoothing_enabled = false)
	LevelManager.level_loaded.connect(func():
		reset_smoothing()
		self.position_smoothing_enabled = true)
	
	if LevelManager.current_tilemap_bounds.size() >=2:
		set_camera_limit(LevelManager.current_tilemap_bounds)
	reset_smoothing()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_camera_limit(new_bounds: Array[Vector2]) -> void:
	#if !new_bounds:
		#return
	print('set camera limit', new_bounds)
	self.limit_left = int(new_bounds[0].x)
	self.limit_top = int(new_bounds[0].y)
	self.limit_right = int(new_bounds[1].x)
	self.limit_bottom = int(new_bounds[1].y)

	pass
