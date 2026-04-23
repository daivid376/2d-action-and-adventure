@tool
class_name PersistentComponent extends Node
var persistent_id : String = ''
var states := {} #{'chest_state' : ChestState.CLOSED}
var persistent_field_values = {} #{'parent.global_position':Vector2}
@export var tracked_properties : Array[PersistentPropertyBinding] : set = _set_tracked_properties
func _ready() -> void:
	if Engine.is_editor_hint():
		#set_process(true)
		#_rewrite_bindings()
		return
	#SaveManager.game_loaded.connect(_on_game_loaded)
	SaveManager.game_start_saving.connect(capture_persistent_states)
	_make_persistent_id()
	restore_persistent_states()
	pass
func _exit_tree() -> void:
	capture_persistent_states()

func _make_persistent_id()->String:
	#'res://levels/area01/01.tscn/TheasureChest2'
	var level_path = get_tree().current_scene.scene_file_path
	persistent_id = level_path.path_join(get_parent().name)
	return persistent_id

func _set_tracked_properties(value)->void:
	tracked_properties = value
	for p in tracked_properties:
		if p:
			p.resolve_target(self)

func capture_persistent_states()-> void:
	WorldState.set_object_states(persistent_id,states)
	var property_values = {}
	for property in tracked_properties:
		var target_node = get_node(property.target_node_path)
		var value = target_node.get_indexed(property.property_path)
		var key = '%s|%s' % [str(property.target_node_path) ,property.property_path]
		property_values[key] = value
	WorldState.set_object_persistent_properties(persistent_id,property_values)
	print('captured property_values for %s: %s' % [persistent_id, property_values])
		
		
func restore_persistent_states()-> void:
	states = WorldState.get_object_states(persistent_id)
	for state_name in states:
		self.set(state_name,states[state_name])
	var property_values :Dictionary =  WorldState.get_object_persistent_properties(persistent_id)
	for property_name in property_values:
		var target_node_path = property_name.split('|')[0]
		var property_path = property_name.split('|')[1]
		var target_node = get_node(NodePath(target_node_path))
		print('...target_node...',target_node)
		var value = property_values[property_name]
		print('....restore value...',value)
		target_node.set_indexed(NodePath(property_path),value)
		
func _on_game_loaded()->void:
	print('on game loaded : ',self ,' object_persistent_properties=', WorldState.object_persistent_properties)
	restore_persistent_states()
