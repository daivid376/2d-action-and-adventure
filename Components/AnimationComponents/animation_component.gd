class_name AnimationComponent extends Node

@onready var animation_player: AnimationPlayer = self.get_parent().get_node_or_null("AnimationPlayer") as AnimationPlayer
@onready var sprite_2d: Sprite2D = self.get_parent().get_node_or_null("Sprite2D") as Sprite2D
@onready var movement_component : MovementComponent = self.get_parent().get_node("MovementComponent") as MovementComponent
var current_state : String = 'idle'
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movement_component.direction_changed.connect(_on_direction_changed)
	pass # Replace with function body.

func set_current_state(new_state:String) -> void:
	current_state = new_state

func update_animation() -> void:
	var play_anim : String = current_state + '_' + movement_component.get_animation_direction_name()
	if not animation_player.has_animation(play_anim):
		push_error('Animation not found: ' + play_anim)
		return 
	elif animation_player.current_animation != play_anim:
		animation_player.play(play_anim)

func _on_direction_changed(_new_direction: MovementComponent.FacingDirection)-> void:
	flip_scale_x(_new_direction)
	if current_state in ['walk','idle']:
		update_animation()

func flip_scale_x(cardinal_direction: MovementComponent.FacingDirection) -> void:
	if !sprite_2d:
		return
	var abs_scale_x = abs(sprite_2d.scale.x)
	sprite_2d.scale.x = -1 * abs_scale_x if cardinal_direction == MovementComponent.FacingDirection.LEFT else abs_scale_x
