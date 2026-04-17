extends Node

const PLAYER = preload("res://Actors/Player/player.tscn") as PackedScene
const INVENTORY = preload("res://GUI/pause_menu/inventory/player_inventory.tres") as Inventory

signal interact_requested

var player: Player
var player_spawned : bool = false

func _ready() -> void:
	spawn_player()
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('interact'):
		var current_state := player.state_machine.current_state
		if current_state is StateWalk or current_state is StateIdle:
			interact_requested.emit()
	pass
func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player)
	
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
