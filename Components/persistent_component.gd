class_name PersistentComponent extends Node
@export var persistent_id : String = ''
@export var is_unique : bool = false
#var states := {} #{'chest_state' : ChestState.CLOSED}
#@export var persistent_fields : Array[StringName] = []
var parent : Node
@export_node_path('Node') var persistent_target_node_path : NodePath = ^'..'
@export var target_property := &''
var host_node : Node
var target_object : Object
func _ready() -> void:
	pass
		
func _enter_tree() -> void:
	host_node = get_node(persistent_target_node_path)
	target_object  = _resolve_target_object()
	parent = get_parent()
	if persistent_id.is_empty():
		_make_persistent_id()
	PersistentDataManager.register_persistent_object(target_object,persistent_id)
	PersistentDataManager.apply_persistent_data(persistent_id)

func _exit_tree() -> void:
	if not SaveManager.is_game_loading:
		PersistentDataManager.capture_persistent_data(persistent_id)
	PersistentDataManager.unregister_persistent_object(persistent_id)

func _make_persistent_id()->String:
	#'res://levels/area01/01.tscn/TheasureChest2'
	var level_path = get_tree().current_scene.scene_file_path
	var node_name : String= String(parent.name)
	var relative_target_node_path :String = String(parent.get_path_to(host_node))
	if host_node != parent:
		node_name = node_name.path_join(relative_target_node_path)
	if not target_property.is_empty():
		node_name = node_name.path_join(String(target_property))
		
	persistent_id = level_path.path_join(node_name)
	if is_unique:
		persistent_id = node_name
	return persistent_id

func _resolve_target_object() -> Object:
	if target_property.is_empty():
		return host_node

	if not (target_property in host_node):
		push_error("PersistentComponent: property not found: %s" % target_property)
		return null

	var value = host_node.get(target_property)
	if value == null:
		push_error("PersistentComponent: property is null: %s" % target_property)
		return null

	if value is Object:
		return value

	push_error("PersistentComponent: property is not an Object: %s" % target_property)
	return null
		
#func _on_game_loaded()->void:
	#print('on game loaded : ',self ,' object_persistent_properties=', WorldState.object_persistent_properties)
	#restore_persistent_states()
