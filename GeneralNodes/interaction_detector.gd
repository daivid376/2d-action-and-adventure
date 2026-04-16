class_name InteractionDetector extends Area2D

var interactables_in_range :Array[Interactable] = []

func _ready() -> void:
	self.area_entered.connect(_on_area_entered)
	self.area_exited.connect(_on_area_exited)
	PlayerManager.interact_requested.connect(_on_interact_requested)
	
func _on_area_entered(area:Area2D)->void:
	var interactable := area.get_parent() as Interactable
	if interactable and !interactables_in_range.has(interactable):
		interactables_in_range.append(interactable)
		print('interactables_in_range',interactables_in_range)
		
func _on_area_exited(area:Area2D)->void:
	var interactable := area.get_parent() as Interactable
	if interactable:
		interactables_in_range.erase(interactable)
		print('interactables_in_range exit',interactables_in_range)
	
func _on_interact_requested()->void:
	for interactable in interactables_in_range:
		interactable.interact()
