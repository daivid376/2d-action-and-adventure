extends Area2D

var pushables := []

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(_body:Node2D)->void:
	print('onbody entered ,body: ',_body)
	if _body is Pushable_Statue:
		_body.push_direction = PlayerManager.player.movement_component.get_direction()
	
	
func _on_body_exited(_body:Node2D)->void:
	if _body is Pushable_Statue:
		_body.push_direction = Vector2.ZERO
