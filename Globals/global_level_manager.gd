extends Node

var current_tilemap_bounds: Array[ Vector2 ]
signal tilemap_bounds_changed(bounds : Array[Vector2])
signal level_load_started
signal level_loaded

func _ready() -> void:
	pass
func change_tilemap_bounds(new_bounds: Array[Vector2]):
	current_tilemap_bounds = new_bounds
	tilemap_bounds_changed.emit(new_bounds)
	pass

	
func load_new_level_by(level_transition_triggering: LevelTransition)-> void:
	var scene_path : String = level_transition_triggering.level_to_load
	var level_transition_triggering_position := level_transition_triggering.position
	var level_transition_triggering_size : int = level_transition_triggering.size
	var target_transition_area_name : String = level_transition_triggering.target_transition_area
	await load_level(scene_path)
	var target_transition_area: LevelTransition = get_tree().current_scene.get_node(target_transition_area_name) as LevelTransition
	PlayerManager.player.teleport(\
	target_transition_area.get_transition_target_position(\
	level_transition_triggering_position,\
	level_transition_triggering_size))
	
func load_level(scene_path)->void:
	level_load_started.emit()
	await SceneTransitionGui.fade_out()
	get_tree().paused = true
	# wait previous level to be queue free
	await get_tree().process_frame
	get_tree().change_scene_to_file(scene_path)
	await get_tree().scene_changed
	
	get_tree().paused = false
	level_loaded.emit()
	await  SceneTransitionGui.fade_in()
	pass

#func teleport_player(target_pos :Vector2)->void:
	#player.camera.position_smoothing_enabled = false
	#player.global_position = target_pos
	#player.camera.reset_smoothing()
	#player.camera.position_smoothing_enabled = true
	
