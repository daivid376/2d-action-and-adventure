class_name InventoryToastPresnter extends Node

static func format_inventory_toast(item:Item,count:int, event_type:StringName)-> String:
	return _format_action(item,count,event_type)
	#match event_type:
		#InventoryEvent.ADDED:
			#return _format_action(item,count,'obtained')
		#InventoryEvent.USED:
			#return _format_action(item,count,'used')
		#_:
			#return ''
			
static func _format_action(input_item: Item, count : int,event_type:StringName)->String:
	#var formated_text :String= '{action} {item_name}'.format({action = action,item_name = TranslationServer.translate(input_item.name_key) })
	#var formated_text :String= '{event_type} {item_name}'.format(
		#{event_type = TranslationServer.translate(event_type),
		#item_name = TranslationServer.translate(input_item.name_key) })
	var tr_item_name := TranslationServer.translate(input_item.name_key)
	var formated_text : String = TranslationServer.translate(event_type).format({item = tr_item_name})
	if count > 1:
		formated_text += ' x' + str(count)
	return formated_text
