extends Node

const PLAYER = preload("res://Actors/Player/player.tscn") as PackedScene
const INVENTORY = preload("res://GUI/pause_menu/inventory/player_inventory.tres") as Inventory

signal interact_pressed

var player: Player
var player_spawned : bool = false

func _ready() -> void:
	spawn_player()
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
