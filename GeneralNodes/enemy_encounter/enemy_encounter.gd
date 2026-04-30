@tool
class_name EnemyEncounter extends Node2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var bg: Sprite2D = $bg
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var enemies : Array[NodePath] = []
@export var loot_item : Item :
	set(value):
		loot_item = value
		_update_preview()

var item_pickup_scene : PackedScene = preload("res://items/item_pickup/item_pickup.tscn")

var remaining_enemy_count := 0
var is_completed: bool = false
var is_loot_collected : bool = false
const PERSISTENT_PROPERTIES := ['is_completed','is_loot_collected']

func _ready() -> void:
	if Engine.is_editor_hint():
		sprite_2d.visible = true
		bg.visible = true
		return
	sprite_2d.visible = false
	bg.visible = false
	
	for enemy_path in enemies:
		var enemy := get_node_or_null(enemy_path) as Enemy
		if !enemy:
			return
		if is_completed:
			enemy.visible = false
			enemy.call_deferred('queue_free')
			continue
		remaining_enemy_count += 1
		enemy.died.connect(_on_enemy_died)
		
	if is_completed and not is_loot_collected:
		spawn_loot(false)
		
func _on_enemy_died() -> void:
	remaining_enemy_count -= 1
	print(remaining_enemy_count)
	if is_encounter_comleted():
		print('slaying finish')
		spawn_loot(true)
		is_completed = true
	
func is_encounter_comleted() -> bool:
	if remaining_enemy_count == 0:
		return true
	return false
	
func spawn_loot(first_time_spawn:bool) -> void:
	var loot_item_pickup := item_pickup_scene.instantiate() as ItemPickup
	loot_item_pickup.item = loot_item
	print('loot ceated ',loot_item_pickup)
	loot_item_pickup.global_position = self.global_position
	loot_item_pickup.picked_up.connect(func(): is_loot_collected = true)
	get_tree().current_scene.call_deferred("add_child", loot_item_pickup)
	if first_time_spawn:
		audio_stream_player_2d.play()
		loot_item_pickup.play_drop_animation_on_ready = true
		
func _update_preview()->void:
	if sprite_2d:
		if loot_item:
			sprite_2d.texture = loot_item.texture
		else:
			sprite_2d.texture = null
			
