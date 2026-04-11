class_name ItemData extends Resource
@export var texture : Texture2D
@export var item_name : String = ''
@export_multiline var description : String = ''
@export var effects : Array[ItemEffect]

func use()->bool:
	if effects.size() == 0:
		return false
	for e in effects:
		if e:
			e.use()
	return true
