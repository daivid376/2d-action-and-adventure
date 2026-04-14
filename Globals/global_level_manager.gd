extends Node
const PLAYER = preload("res://Actors/Player/player.tscn")
var player: Player
var current_tilemap_bounds: Array[ Vector2 ]
signal tilemap_bounds_changed(bounds : Array[Vector2])
signal level_load_started
signal level_loaded

func _ready() -> void:
	spawn_player()
	pass
func change_tilemap_bounds(new_bounds: Array[Vector2]):
	print('change_tilemap_bounds, in levelmanager')
	current_tilemap_bounds = new_bounds
	print(new_bounds)
	tilemap_bounds_changed.emit(new_bounds)
	pass
func spawn_player()->void:
	player = PLAYER.instantiate() as Player
	var current_scene = get_tree().current_scene
	current_scene.add_child(player)
	var spawn = get_tree().current_scene.get_node('%PlayerSpawn') as Marker2D
	if spawn:
		player.global_position = spawn.global_position
	pass

func set_player_parent(parent)-> void:
	if player.get_parent() == parent:
		return
	parent.add_child(player)
func unparent_player()->void:
	var parent = player.get_parent()
	parent.remove_child(player)
	
func load_new_level_by(level_transition_triggering: LevelTransition):
	print('level_transition_triggering ',level_transition_triggering)
	var scene_path : String = level_transition_triggering.level_to_load
	var target_transition_area_name : String = level_transition_triggering.target_transition_area
	
	await load_level(scene_path)
	var target_transition_area: LevelTransition = get_tree().current_scene.get_node(target_transition_area_name) as LevelTransition
	player.teleport(player.global_position + target_transition_area.get_offset())
	
func load_level(scene_path)->void:
	await SceneTransitionGui.fade_out()
	get_tree().paused = true
	level_load_started.emit()
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
	
