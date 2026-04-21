class_name LootComponent extends Node
@export var loot_entries : Array[LootEntry]
static var ITEM_PICKUP:PackedScene = null


static func _load_item_pickup()-> void:
	if ITEM_PICKUP == null:
		ITEM_PICKUP = load("res://items/item_pickup/item_pickup.tscn")
#func test():
	#var t_rng: RandomNumberGenerator = RandomNumberGenerator.new()
	#var seed = hash('wertwe')
	#t_rng.seed = seed
	#var random = t_rng.randi()
	#t_rng.randomize()
	#randomize()
func drop()->void:
	_load_item_pickup()
	for loot_entry in loot_entries:
		if !loot_entry or !loot_entry.item:
			continue
		var drop_count : int = loot_entry.get_drop_count()
		var rand_index_offset : int = randi()
		for i in drop_count:
			_create_loot_pickup(loot_entry,i + rand_index_offset)
			
func _create_loot_pickup(loot_entry : LootEntry, rand_seed :int):
	var item_pickup := ITEM_PICKUP.instantiate() as ItemPickup
	item_pickup.item = loot_entry.item
	var parent : Actor = self.get_parent() as Actor
	item_pickup.global_position = parent.global_position
	#var hash_seed :int = MathUtils.hash_u32(rand_seed)
	item_pickup.pending_drop_speed = parent.movement_component.speed * 0.34 * randf_range(0.75,1.25)
	var pending_drop_dir:Vector2 = parent.movement_component.get_direction()
	pending_drop_dir = pending_drop_dir.rotated(GoldenSeq.get_rand_angle(15.,rand_seed, 0.376)) 
	
	item_pickup.rand_index = rand_seed
	item_pickup.pending_drop_dir = pending_drop_dir
	item_pickup.pending_deceleration = 100.
	item_pickup.play_drop_animation_on_ready = true
	get_tree().current_scene.call_deferred('add_child',item_pickup)
#GoldenSeq.rand_around(hash_seed,0.34,0.25,0.5689,GoldenSeq.ALPHA_SILVER)
