class_name ToastContainer extends VBoxContainer

var activating_toasts : Array[ToastItem] = []
@export var toast_item_scene : PackedScene


func show_toast(text : String,icon : Texture2D = null)->void:
	if text.is_empty() or !text:
		return
	var new_toast := toast_item_scene.instantiate() as ToastItem
	self.add_child(new_toast)
	move_child(new_toast,0)
	
	#await new_toast.ready
	new_toast.setup(text,icon)
	#new_toast.set_anchor()
	new_toast.play()
	
	pass
