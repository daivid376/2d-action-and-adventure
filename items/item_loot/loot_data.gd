class_name LootEntry extends Resource
@export var item : Item
@export_range(0.,100.,1.,'suffix:%') var probability : float = 80.
@export_range(1,10,1,'suffix:items') var min_amout : int = 1
@export_range(1,10,1,'suffix:items') var max_amout : int = 1

func get_drop_count()-> int:
	if randf_range(0,100.) >= probability:
		return 0
	else:
		return randi_range(min_amout,maxi(min_amout,max_amout))
