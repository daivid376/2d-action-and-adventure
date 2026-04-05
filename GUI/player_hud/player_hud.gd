extends CanvasLayer
@export var heart_scene : PackedScene
@onready var hearts_container: HFlowContainer = $Control/HFlowContainer

func update_hp_display(_hp:float,_max_hp:float)->void:
	var prev_heart_count:int = hearts_container.get_children().size()
	var current_heart_count :int = int(round(_max_hp *0.5))
	var delta_heart_count : int = current_heart_count - prev_heart_count
	var remaining_hp : int = int(round(_hp))
	if delta_heart_count >0:
		for i in range(delta_heart_count):
			var heart = heart_scene.instantiate() as HeartGUI
			hearts_container.add_child(heart)
	else:
		for i in range(abs(delta_heart_count)):
			var last_id = prev_heart_count -1 -i
			hearts_container.get_child(last_id).queue_free()
	for i in range(current_heart_count):
		var value = clamp(remaining_hp,0,2)
		hearts_container.get_child(i).set_heart_display(value)
		remaining_hp -= value
