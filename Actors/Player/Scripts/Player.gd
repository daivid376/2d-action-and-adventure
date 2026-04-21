class_name Player extends Actor
@onready var camera :Camera2D = self.get_node_or_null('Camera2D')
var input_direction : Vector2 = Vector2.ZERO
@export var inventory : Inventory
const SAVE_FIELDS:Array = ['hp','max_hp','global_position']

		
func _ready():
	super()
	PlayerHud.update_hp_display(hp,max_hp)
	self.hp_changed.connect(_on_hp_changed)
	self.died.connect(_on_died)
	SaveManager.register_savable(self,'player')
	SaveManager.game_loaded.connect(_on_game_loaded)
func can_be_saved()->bool:
	return true
func teleport(target_pos: Vector2)->void:
	self.camera.position_smoothing_enabled = false
	self.global_position = target_pos
	self.camera.reset_smoothing()
	self.camera.position_smoothing_enabled = true
	PlayerManager.player_teleported.emit()

func _on_game_loaded()->void:
	self.camera.position_smoothing_enabled = false
	self.camera.reset_smoothing()
	self.camera.position_smoothing_enabled = true

func _physics_process(_delta: float) -> void:
	input_direction = Input.get_vector("move_left",'move_right','move_up','move_down')


func _on_died(_hit_box:HitBox) -> void:
	update_hp(max_hp)
	print('Player Died')
func _on_hp_changed(current_hp:float,current_max_hp):
	PlayerHud.update_hp_display(current_hp,current_max_hp)
