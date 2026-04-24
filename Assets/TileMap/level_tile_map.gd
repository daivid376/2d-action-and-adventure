class_name LevelTileMap extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.change_tilemap_bounds(get_tilemap_bounds())
	LevelManager.tilemap_bounds_changed.connect(get_tilemap_bounds)



func get_tilemap_bounds() -> Array[Vector2]:
	var bounds : Array[Vector2] = []
	
	bounds.append(Vector2(self.get_used_rect().position *rendering_quadrant_size))
	bounds.append(Vector2(self.get_used_rect().end *rendering_quadrant_size))
	#print('bounds',bounds)
	return bounds
