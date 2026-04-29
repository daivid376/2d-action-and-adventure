class_name Item extends Resource
@export var texture : Texture2D
@export var name_key : StringName = ''
@export var description_key : StringName = ''
@export_category('Item Use Effect')
@export var effects : Array[ItemEffect]

func use(count :int)->bool:
	if effects.size() == 0:
		return false
	for e in effects:
		if e:
			for i in count:
				e.use()
	return true

func get_save_value()-> String:
	return self.resource_path
	
func get_load_value(path : String)-> Item:
	return ResourceLoader.load(path) as Item
