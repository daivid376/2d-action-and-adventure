class_name Item extends Resource
@export var texture : Texture2D
@export var item_name : String = ''
@export_multiline var description : String = ''
@export_category('Item Use Effect')
@export var effects : Array[ItemEffect]

func use()->bool:
	if effects.size() == 0:
		return false
	for e in effects:
		if e:
			e.use()
	return true

func get_save_value()-> String:
	return self.resource_path
	
func get_load_value(path : String)-> Item:
	return ResourceLoader.load(path) as Item
