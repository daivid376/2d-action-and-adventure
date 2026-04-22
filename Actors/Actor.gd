class_name Actor extends CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var state_machine: StateMachine = self.get_node_or_null('StateMachine')
@onready var movement_component : MovementComponent = self.get_node_or_null('MovementComponent')
@onready var animation_component : AnimationComponent = self.get_node_or_null('AnimationComponent')
@onready var loot_component : LootComponent = self.get_node_or_null('LootComponent')
@onready var hurt_box : HurtBox = self.get_node_or_null('HurtBox')
@onready var hit_box: HitBox = self.get_node_or_null('HitBox')

@export var max_hp: float = 6.:
	set(_v):
		max_hp = _v
		hp_changed.emit(hp,max_hp)

var hp: float = max_hp:
	set(_v):
		hp = _v
		hp_changed.emit(hp,max_hp)

var invulnerable: bool = false

signal damaged(hit_box : HitBox)
signal died(hit_box : HitBox)
signal hp_changed(current_hp:float,current_max_hp: float)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	LevelManager.level_load_started.connect(_disable_collision)
	LevelManager.level_loaded.connect(_enable_collision)
	if state_machine:
		state_machine.init(self)
	if hurt_box:
		hurt_box.damaged.connect(_take_damage)
	hp = max_hp
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _disable_collision()->void:
	collision_shape_2d.set_deferred('disabled',true)

func _enable_collision()->void:
	await get_tree().process_frame
	collision_shape_2d.set_deferred('disabled',false)

func _take_damage(in_hit_box : HitBox) -> void:
	if invulnerable:
		return
	update_hp(-in_hit_box.damage)
	if hp > 0.:
		damaged.emit(in_hit_box)
	else:
		died.emit(in_hit_box)
	return
func update_hp(delta: float)-> void:
	hp = clamp(hp + delta,0.0,max_hp)
	hp_changed.emit(hp,max_hp)
func update_max_hp(delta: float)->void:
	max_hp = max(max_hp + delta,0.0,)
	hp = min(hp,max_hp)
	hp_changed.emit(hp,max_hp)
	
func make_invulnerable(_duration:float = 0.5)->void:
	invulnerable = true
	if hurt_box:
		hurt_box.monitoring = false
	await get_tree().create_timer(_duration).timeout
	invulnerable = false
	if hurt_box:
		hurt_box.monitoring = true
func can_be_saved()->bool:
	return false
