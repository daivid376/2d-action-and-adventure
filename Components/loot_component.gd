class_name LootComponent extends Node
@export var loot_entries : Array[LootEntry]
static var ITEM_PICKUP:PackedScene = null

static func _load_item_pickup()-> void:
	if ITEM_PICKUP == null:
		ITEM_PICKUP = load("res://items/item_pickup/item_pickup.tscn")

func drop()->void:
	_load_item_pickup()
	for loot_entry in loot_entries:
		if !loot_entry or !loot_entry.item:
			continue
		var drop_count : int = loot_entry.get_drop_count()
		for i in drop_count:
			_create_loot_pickup(loot_entry)
			
func _create_loot_pickup(loot_entry : LootEntry):
	var item_pickup := ITEM_PICKUP.instantiate() as ItemPickup
	item_pickup.item = loot_entry.item
	var parent : Actor = self.get_parent() as Actor
	item_pickup.global_position = parent.global_position
	item_pickup.pending_drop_speed = parent.movement_component.speed*0.37* randf_range(0.7,1.3)
	
	var pending_drop_dir:Vector2 = parent.movement_component.get_direction()
	pending_drop_dir = _get_random_dir(pending_drop_dir,15.)
	
	item_pickup.pending_drop_dir = pending_drop_dir
	item_pickup.pending_deceleration = 100.
	item_pickup.play_drop_animation_on_ready = true
	get_tree().current_scene.call_deferred('add_child',item_pickup)

func _get_random_dir(base_dir:Vector2,random_degree:float)->Vector2:
	var max_angle_offset = deg_to_rad(random_degree)
	var rand_angle_offset = randf_range(-max_angle_offset,max_angle_offset)
	return base_dir.rotated(rand_angle_offset)
