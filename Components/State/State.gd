class_name State extends Node

var actor : Actor:
	set(value):
		actor = value
		_on_actor_assigned()
	get:
		return actor
func _on_actor_assigned()->void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
#what happens when the player enters this State?
func enter()-> void:
	pass
#what happens during the _process update in this State?
func process(_delta: float)-> State:
	return null
#what happens when the player exit this State?
func exit()-> void:
	pass

#what happens during the _physics_process update in this State?
func physics_process(_delta: float)-> State:
	return null

#what happens with input events in this State?
func handle_input(_event: InputEvent)-> State:
	return null
