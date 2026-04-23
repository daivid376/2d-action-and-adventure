@tool
class_name PersistentPropertyBinding extends Resource
@export_node_path('Node') var target_node_path : NodePath = ^'..'
@export var property_path : String = 'global_position' :set = _set_property_path
var target_node : Node
#func _init() -> void:
	
func _set_property_path(value)->void:
	print('target_node',target_node)
	if value not in target_node:
		push_error("property not found: %s" % value)
	property_path = value
	
	
func resolve_target(context_node: Node)->void:
	target_node = context_node.get_node_or_null(target_node_path)
